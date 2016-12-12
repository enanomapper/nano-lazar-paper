#!/usr/bin/env ruby
require_relative "setup.rb"

ec50 = Feature.find_by(name: "Cell Viability Assay EC50")
ec25 = Feature.find_by(name: "Cell Viability Assay EC25")
training_dataset = Dataset.find_or_create_by(:name => "MODENA")

algorithms = [
  { :descriptors => { :method => "properties", :categories => ["P-CHEM"], }, },
=begin
  {
    :descriptors => { :method => "fingerprint", :type => "MP2D", },
    :feature_selection => nil,
    :similarity => {
      :method => "Algorithm::Similarity.tanimoto",
      :min => 0.1
    },
  },
=end
]

prediction_methods = [
      "Algorithm::Regression.weighted_average",
      "Algorithm::Caret.pls",
      "Algorithm::Caret.rf",
]

[ec50,ec25].each do |f|
  algorithms.each_with_index do |a,i|
    prediction_methods.each do |m|
      a[:prediction] ||= {}
      a[:prediction][:method] = m
      m = Model::Validation.from_enanomapper training_dataset:training_dataset, prediction_feature:f, algorithms:a
      File.open(File.join(RESULTS_DIR,"modena-validation.ids"),"a+"){|f| f.puts m.id.to_s}
    end
  end
end
