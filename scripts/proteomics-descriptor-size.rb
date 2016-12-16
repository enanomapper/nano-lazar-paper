#!/usr/bin/env ruby
require_relative "setup.rb"

File.open(File.join(RESULTS_DIR,"protein-corona-validation.ids")).each_line do |id|
  model = Model::Validation.find(id.chomp)
  if model.algorithms["descriptors"]["categories"] == ["Proteomics"] and model.algorithms["prediction"]["method"] == "Algorithm::Caret.rf"
    before = model.model.substances.first.properties.select{|id,v| Feature.find(id)["category"] == "Proteomics"}.size
    after = model.model.independent_variables.size
    r = {:before_feature_selection => before, :after_feature_selection => after}
    File.open(File.join(RESULTS_DIR,"proteomics-descriptor-size.json"),"w+"){|f| f.puts JSON.pretty_generate(r)}
  end
end

