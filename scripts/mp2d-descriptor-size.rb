#!/usr/bin/env ruby
require_relative "setup.rb"

File.open(File.join(RESULTS_DIR,"protein-corona-validation.ids")).each_line do |id|
  model = Model::Validation.find(id.chomp)
  if model.algorithms["descriptors"]["method"] == "fingerprint" and model.algorithms["prediction"]["method"] == "Algorithm::Caret.rf"
    File.open(File.join(RESULTS_DIR,"mp2d-descriptor-size.json"),"w+"){|f| f.puts JSON.pretty_generate(model.model.independent_variables.size)}
  end
end

