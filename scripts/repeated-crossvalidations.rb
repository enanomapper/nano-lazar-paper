require_relative "setup.rb"

prediction_feature = Feature.find_or_create_by(name: "log2(Net cell association)", category: "TOX")
training_dataset = Dataset.find(File.read(File.join(RESULTS_DIR,"training-dataset.id")).chomp)

algorithms = [
  {
    :descriptors => { :method => "fingerprint", :type => "MP2D", },
    :feature_selection => nil,
    :similarity => {
      :method => "Algorithm::Similarity.tanimoto",
      :min => 0.1
    },
  },
  #{ :descriptors => { :method => "properties", :categories => ["P-CHEM"], }, },
  { :descriptors => { :method => "properties", :categories => ["Proteomics"], }, },
  { :descriptors => { :method => "properties", :categories => ["P-CHEM","Proteomics"], }, }
]

prediction_methods = [
      "Algorithm::Regression.weighted_average",
      "Algorithm::Caret.pls",
      "Algorithm::Caret.rf",
]

algorithms.each_with_index do |a,i|
  prediction_methods.each do |m|
    a[:prediction] ||= {}
    a[:prediction][:method] = m
    m = Model::Validation.from_enanomapper algorithms:a
    File.open(File.join(RESULTS_DIR,"prediction-models.ids"),"a+"){|f| f.puts m.id.to_s}
  end
end

=begin
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

File.open(File.join(RESULTS_DIR,"repeated-crossvalidatios.json"),"w+"){|f| f.puts JSON.pretty_generate(results)}
=end
