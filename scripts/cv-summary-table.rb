#!/usr/bin/env ruby
require_relative "setup.rb"

model_validations = JSON.parse(File.read(File.join("results","validation-summaries.json")))
rmse = []
r_squared = []
within_pi = []
names = []
experiments = []
rmse_means = {}
r_squared_means = {}
within_pi_means = {}
model_validations.each do |mv|
  # convert to R compatible names
  if mv["descriptors"]["categories"]
    name = "#{mv["descriptors"]["categories"].collect{|c| c.gsub("-","")}.join "_"}."
  else
    name = mv["descriptors"]["type"] + "."
  end
  name += mv["prediction"]["method"].split('.').last
  rmse_means[name] = mv["rmse"].mean
  r_squared_means[name] = mv["r_squared"].mean
  within_pi_means[name] = mv["percent_within_prediction_interval"].mean unless mv["percent_within_prediction_interval"].compact.empty?
  rmse += mv["rmse"]
  r_squared += mv["r_squared"]
  within_pi += mv["percent_within_prediction_interval"]
  mv["rmse"].size.times{ names << name }
  mv["descriptors"]["categories"] ? type = mv["descriptors"]["categories"].join(" ") : type = mv["descriptors"]["type"]
  algo = mv["prediction"]["method"]
  algo = "wa" if algo == "weighted_average"
  experiments << {
    :type => type,
    :algorithm => algo,
    :r_squared => mv["r_squared"],
    :rmse => mv["rmse"],
    :percent_within_prediction_interval => mv["percent_within_prediction_interval"],
    :nr_unpredicted => mv ["nr_unpredicted"]
  }
end

# statistics
min_rmse = rmse_means.values.min
max_r_squared = r_squared_means.values.max
max_within_pi = within_pi_means.values.max

R.assign "names", names.collect{|n| n.sub("weighted_average","wa")}
R.assign "rmse", rmse
R.assign "r_squared", r_squared
R.assign "within_pi_names", names.select{|n| !n.match("weighted_average")}
R.assign "within_pi", within_pi

R.eval "anova.rmse = aov(rmse ~ names)"
best_rmse = rmse_means.select{|n,v| v == min_rmse}.keys.first

R.eval "anova.r = aov(r_squared ~ names)"
best_r_squared = r_squared_means.select{|n,v| v == max_r_squared}.keys.first

R.eval "anova.within_pi = aov(within_pi ~ within_pi_names)"
best_within_pi = within_pi_means.select{|n,v| v == max_within_pi}.keys.first

significant_differences = {}
# ugly hack, because R.eval("TukeyHSD(anova.r)").to_ruby returns only the result matrix, but no comparison names
path = File.join File.expand_path(File.dirname(__FILE__)), "..", "results"

# print to file
file = File.join path, "r_squared.txt"
R.eval "sink('#{file}')"
R.eval "print(TukeyHSD(anova.r))"
R.eval "sink()"
significant_differences[:r_squared] = {}
# read results
`sed '0,/p adj/d' #{file} `.each_line do |line|
  line.chomp!
  unless line.empty?
    comparison, p = line.split
    if p.to_f < 0.05 and comparison.match(best_r_squared)
      comp = comparison.split("-")
      comp.delete(best_r_squared)
      significant_differences[:r_squared][comp[0].sub("PCHEM","P-CHEM").sub("_"," ")] = p.to_f #if comp.size == 1
    end
  end
end

# print to file
file = File.join path, "rmse.txt"
R.eval "sink('#{file}')"
R.eval "print(TukeyHSD(anova.rmse))"
R.eval "sink()"
significant_differences[:rmse] = {}
# read results
`sed '0,/p adj/d' #{file} `.each_line do |line|
  line.chomp!
  unless line.empty?
    comparison, p = line.split
    if p.to_f < 0.05 and comparison.match(best_rmse)
      comp = comparison.split("-")
      comp.delete(best_rmse)
      significant_differences[:rmse][comp[0].sub("PCHEM","P-CHEM").sub("_"," ")] = p.to_f 
    end
  end
end

# print to file
file = File.join path, "within_pi.txt"
R.eval "sink('#{file}')"
R.eval "print(TukeyHSD(anova.within_pi))"
R.eval "sink()"
significant_differences[:within_pi] = {}
# read results
`sed '0,/p adj/d' #{file} `.each_line do |line|
  line.chomp!
  unless line.empty?
    comparison, p = line.split
    if p.to_f < 0.05 and comparison.match(best_within_pi)
      comp = comparison.split("-")
      comp.delete(best_within_pi)
      significant_differences[:within_pi][comp[0].sub("PCHEM","P-CHEM").sub("_"," ")] = p.to_f 
    end
  end
end

best_rmse = best_rmse.sub("PCHEM","P-CHEM").sub("_"," ")
best_r_squared = best_r_squared.sub("PCHEM","P-CHEM").sub("_"," ")
best_within_pi = best_within_pi.sub("PCHEM","P-CHEM").sub("_"," ")

table = "Descriptors , Algorithm , RMSE , $r^2$ , \% within prediction interval \n"

experiments.each do |e|
  within_pi = e[:percent_within_prediction_interval].collect{|v| v.round}.join " "
  within_pi = "NA" if within_pi.empty?
  algo = e[:algorithm].split('.').last.sub("weighted_average","wa")
  r_sq = e[:r_squared].collect{|v| v.round(2)}.join " "
  if best_r_squared == "#{e[:type]}.#{algo}"
    r_sq = "**#{r_sq}**" # best results bold
  elsif significant_differences[:r_squared].keys.include?("#{e[:type]}.#{algo}")
    r_sq = "*#{r_sq}*" # significant differences italics
  end
  rmse = e[:rmse].collect{|v| v.round(2)}.join " "
  if best_rmse == "#{e[:type]}.#{algo}"
    rmse = "**#{rmse}**" # best results bold
  elsif significant_differences[:rmse].keys.include?("#{e[:type]}.#{algo}")
    rmse = "*#{rmse}*" # significant differences italics
  end
  if best_within_pi == "#{e[:type]}.#{algo}"
    within_pi = "**#{within_pi}**" # best results bold
  elsif significant_differences[:within_pi].keys.include?("#{e[:type]}.#{algo}")
    within_pi = "*#{within_pi}*" # significant differences italics
  end
  algo = "wa" if algo == "weighted_average"
  table << "#{e[:type]} , #{algo.upcase} , #{rmse} , #{r_sq} , #{within_pi}\n"
end

File.open(File.join(RESULTS_DIR,"cv-summary-table.csv"),"w+") { |f| f.puts table }
