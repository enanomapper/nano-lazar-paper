#!/usr/bin/env ruby
require_relative "setup.rb"

File.open(File.join(RESULTS_DIR,"protein-corona-validation.ids")).each_line do |id|
  id.chomp!
  model = Model::Validation.find(id)
  if model.algorithms["descriptors"]["categories"]
    file = "#{model.algorithms["descriptors"]["categories"].collect{|c| c.gsub("-","")}.join "."}-"
  else
    file = "MP2D-"
  end
  file += model.algorithms["prediction"]["method"].split('.').last
  model.crossvalidations.each_with_index do |cv,j|
    pdf = File.join(FIG_DIR,"#{file}-#{j}.pdf")
    File.open(pdf,"w+"){|f| f.puts cv.correlation_plot(format: "pdf")}
  end
end
