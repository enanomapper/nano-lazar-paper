#!/usr/bin/env ruby
require_relative "setup.rb"
Import::Enanomapper.import 
protein_corona = Dataset.find_or_create_by(:name => "Protein Corona Fingerprinting Predicts the Cellular Interaction of Gold and Silver Nanoparticles")
modena = Dataset.find_or_create_by(:name => "MODENA")
File.open(File.join(RESULTS_DIR,"training-datasets.json"),"w+") do |f|
  f.puts JSON.pretty_generate({:protein_corona => protein_corona.id.to_s, :modena => modena.id.to_s})
end
