require_relative "setup.rb"
training_dataset_id = File.read(File.join(File.dirname(__FILE__),"..","results","training-dataset.id")).chomp
training_dataset = Dataset.find training_dataset_id
# TODO fix unit (-log10)
feature = Feature.find_or_create_by(name: "Net cell association", category: "TOX", unit: "mL/ug(Mg)")
model = Model::LazarRegression.create(feature, training_dataset, {:prediction_algorithm => "OpenTox::Algorithm::Regression.local_weighted_average", :neighbor_algorithm => "nanoparticle_neighbors"})
#repeated_cv = RegressionCrossValidation.create model
#repeated_cv = RepeatedCrossValidation.create model
#File.open(File.join(RESULTS_DIR,"weighted-average-repeated-crossvalidation.id"),"w+"){|f| f.puts repeated_cv.id}
loo = LeaveOneOutValidation.create model
File.open(File.join(RESULTS_DIR,"weighted-average-loo.id"),"w+"){|f| f.puts loo.id}
p loo

