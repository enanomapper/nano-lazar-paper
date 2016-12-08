#!/usr/bin/env ruby
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
    File.open(File.join(RESULTS_DIR,"model-validation.ids"),"a+"){|f| f.puts m.id.to_s}
  end
end

