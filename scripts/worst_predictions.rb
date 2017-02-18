#!/usr/bin/env ruby
require_relative "setup.rb"

model_validations = JSON.parse(File.read(File.join("results","validation-summaries.json")))
File.open(File.join(RESULTS_DIR,"worst-predictions.csv"),"w+") do |csv|
  csv.puts ["Descriptors","Nanoparticle","CVs","PI distance","Error"].join ","
  File.open(File.join(RESULTS_DIR,"protein-corona-validation.ids")).each_line do |id|
    v = Model::Validation.find id.chomp
    if v.model.algorithms[:prediction][:method] == "Algorithm::Caret.rf"
      worst = {}
      v.crossvalidations.each_with_index do |cv,i|
        cv.worst_predictions.each do |id,pred|
          pred["measurements"].each do |m|
            s = Substance.find id
            worst[s] ||= []
            pred["error"] = (pred["value"] - pred["measurements"].median).abs
            worst[s] << pred
          end
        end
      end
      worst.sort_by{|s,p| [p.size,p.collect{|pred| pred["distance_prediction_interval"]}.median,p.collect{|pred| pred["error"]}.median]}.reverse.each do |s,p|
        descriptors = ["MP2D fingerprints"]
        descriptors = v.model.algorithms[:descriptors][:categories] if v.model.algorithms[:descriptors][:method] == "properties" 
        error = p.collect{|pred| pred["error"]}.median.round(1)
        distance = p.collect{|pred| pred["distance_prediction_interval"]}.median.round(1)
        csv.puts ["\"#{descriptors.join(" and ")}\"", s.name, p.size, distance, error].join(",")
      end
    end
  end
end
