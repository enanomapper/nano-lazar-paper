require_relative "setup.rb"
training_dataset_id = File.read(File.join(File.dirname(__FILE__),"..","results","training-dataset.id")).chomp
training_dataset = Dataset.find training_dataset_id
# TODO fix unit (-log10)
feature = Feature.find_or_create_by(name: "7.99 Toxicity (other) ICP-AES", category: "TOX", unit: "mL/ug(Mg)")
model = Model::LazarRegression.create(feature, training_dataset, {:prediction_algorithm => "OpenTox::Algorithm::Regression.local_physchem_regression", :neighbor_algorithm => "nanoparticle_neighbors"})
repeated_cv = RepeatedCrossValidation.create model
File.open(File.join(File.dirname(__FILE__),"..","results","weighted-average.rb"),"w+") do |f|
  f.puts({:repeated_cv_id => repeated_cv.id})
  repeated_cv.crossvalidations.each do |cv|
    f.puts({cv => cv.statistics})
  end
end
#loo = LeaveOneOutValidation.create model
#p loo

