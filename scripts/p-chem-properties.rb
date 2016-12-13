#!/usr/bin/env ruby
require_relative "setup.rb"

training_dataset = Dataset.find JSON.parse(File.read(File.join(RESULTS_DIR,"training-datasets.json")))["protein_corona"]
csv = "Property, Medium, Unit\n"
csv += training_dataset.substances.first.properties.collect{|k,v| f = Feature.find(k); f if f.category == "P-CHEM"}.compact.collect{|f| [f.name, f.conditions["MEDIUM"], f.unit.empty? ?  "" : "$#{f.unit}$"].join ", "}.join "\n"
File.open(File.join(RESULTS_DIR,"p-chem-properties.csv"),"w+"){|f| f.puts csv}
