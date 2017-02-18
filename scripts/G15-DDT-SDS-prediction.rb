#!/usr/bin/env ruby
require_relative "setup.rb"

model_validations = JSON.parse(File.read(File.join("results","validation-summaries.json")))
#File.open(File.join(RESULTS_DIR,"worst-predictions.csv"),"w+") do |csv|
  #csv.puts ["Descriptors","Nanoparticle","CVs","PI distance","Error"].join ","
  File.open(File.join(RESULTS_DIR,"protein-corona-validation.ids")).each_line do |id|
    v = Model::Validation.find id.chomp
    if v.model.algorithms[:prediction][:method] == "Algorithm::Caret.rf" and v.model.algorithms[:descriptors][:method] == "fingerprint"
      v.crossvalidations.each_with_index do |cv,i|
        cv.worst_predictions.each do |id,pred|
          pred["measurements"].each do |m|
            s = Substance.find id
            if s.name == "G15.DDT@SDS"
            puts [pred["measurements"].median,pred["distance_prediction_interval"],pred["error"]].join ","
              neighbors = pred["neighbors"].sort_by{|n| n["similarity"]}.reverse
              neighbors.each{|n| puts [Substance.find(n["id"]).name, n["measurement"], n["similarity"]].join ","}
            end
          end
        end
      end
    end
  end
#end
