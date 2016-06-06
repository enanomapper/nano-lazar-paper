require_relative "setup.rb"

prediction_feature = Feature.find_or_create_by(name: "Log2 transformed", category: "TOX")
training_dataset = Dataset.find(File.read(File.join(RESULTS_DIR,"training-dataset.id")).chomp)
feature_categories = ["P-CHEM","Proteomics",nil]
prediction_algorithms = [
  { # weighted average
    :prediction_algorithm => "OpenTox::Algorithm::Regression.local_weighted_average"
  },
  { # pls
    :prediction_algorithm => "OpenTox::Algorithm::Regression.local_physchem_regression",
    :prediction_algorithm_parameters => {:method => 'pls'},
  },
  { # random forests
    :prediction_algorithm => "OpenTox::Algorithm::Regression.local_physchem_regression",
    :prediction_algorithm_parameters => {:method => 'rf'},
  }
]

results = {}

prediction_algorithms.each do |algorithm|
  feature_categories.each do |category|
    params = algorithm.merge( {
      :feature_selection_algorithm => :correlation_filter,
      :feature_selection_algorithm_parameters => {:category => category},
      :neighbor_algorithm => "physchem_neighbors",
      :neighbor_algorithm_parameters => {:min_sim => 0.5}
      } )
    model = Model::LazarRegression.create(prediction_feature, training_dataset, params)
    repeated_cv = Validation::RepeatedCrossValidation.create model
    algo = "weighted_average"
    algo = algorithm[:prediction_algorithm_parameters][:method] if algorithm[:prediction_algorithm_parameters]
    algo = "random_forests" if algo == "rf"
    category = "all" unless category
    results[algo] ||= {}
    results[algo][category] ||= {:id => repeated_cv.id.to_s, :cvs => []}
    repeated_cv.crossvalidations.each do |cv|
      results[algo][category][:cvs] << {
        :id => cv.id.to_s,
        :r_squared => cv.r_squared,
        :rmse => cv.rmse,
        :mae => cv.mae
      }
    end
  end
end

File.open(File.join(RESULTS_DIR,"repeated-crossvalidation-ids.json"),"w+"){|f| f.puts JSON.pretty_generate(results)}
