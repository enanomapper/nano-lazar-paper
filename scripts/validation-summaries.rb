#!/usr/bin/env ruby
require_relative "setup.rb"

algorithms = []

File.open(File.join(RESULTS_DIR,"model-validation.ids")).each_line do |id|
  model = Model::Validation.find(id.chomp)
  algorithm = model.algorithms
  algorithm[:r_squared] = []
  algorithm[:rmse] = []
  algorithm[:percent_within_prediction_interval] = []
  model.crossvalidations.each do |cv|
    algorithm[:r_squared] << cv.r_squared
    algorithm[:rmse] << cv.rmse
    algorithm[:percent_within_prediction_interval] << cv.percent_within_prediction_interval unless model.algorithms[:prediction][:method].match /average/
  end
  algorithms << algorithm
end

puts JSON.pretty_generate(algorithms)
File.open(File.join(RESULTS_DIR,"validation-summaries.json"),"w+"){|f| f.puts JSON.pretty_generate(algorithms)}
