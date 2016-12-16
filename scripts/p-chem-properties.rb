#!/usr/bin/env ruby
require_relative "setup.rb"

relevant_descriptors = []
File.open(File.join(RESULTS_DIR,"protein-corona-validation.ids")).each_line do |id|
  model = Model::Validation.find(id.chomp)
  if model.algorithms["descriptors"]["categories"] == ["P-CHEM"] and model.algorithms["prediction"]["method"] == "Algorithm::Caret.rf"
    relevant_descriptors = model.model.descriptor_ids.collect{|id| Feature.find(id)}
  end
end
training_dataset = Dataset.find JSON.parse(File.read(File.join(RESULTS_DIR,"training-datasets.json")))["protein_corona"]
csv = "Property, Medium, Unit\n"
training_dataset.substances.first.properties.each do |k,v|
  f = Feature.find(k)
  if f.category == "P-CHEM"
    f.conditions["MEDIUM"] ? medium = f.conditions["MEDIUM"].sub(/\(.*\)/,'').strip : medium = "-"
    medium = '-' if medium.strip.empty? # fix whitespace media
    f.unit.empty? ?  unit = "" : unit = "$#{f.unit}$" 
    if relevant_descriptors.include? f
      csv += ["**#{f.name}**", "**#{medium}**", unit].join(", ")+"\n"
    else
      csv += [f.name, medium, unit].join(", ")+"\n"
    end
  end
end
File.open(File.join(RESULTS_DIR,"p-chem-properties.csv"),"w+"){|f| f.puts csv}
