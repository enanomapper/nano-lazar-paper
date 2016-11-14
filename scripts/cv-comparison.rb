require_relative "setup.rb"

model_validations = JSON.parse(File.read(File.join("results","validation-summaries.json")))
rmse = []
r_squared = []
experiments = []
rmse_means = {}
r_squared_means = {}
model_validations.each do |mv|
  name = "#{mv["descriptors"]["method"]}."
  name += "#{mv["descriptors"]["categories"].collect{|c| c.gsub("-","")}.join "."}." if mv["descriptors"]["categories"]
  name += mv["prediction"]["method"].split('.').last
  rmse_means[name] = mv["rmse"].mean
  r_squared_means[name] = mv["r_squared"].mean
  rmse += mv["rmse"]
  r_squared += mv["r_squared"]
  mv["rmse"].size.times{ experiments << name }
end

min_rmse = rmse_means.values.min

max_r_squared = r_squared_means.values.max

R.assign "experiments", experiments
R.assign "rmse", rmse
R.assign "r_squared", r_squared

R.eval "anova.rmse = aov(rmse ~ experiments)"
rmse_p = R.eval('summary(anova.rmse)[[1]][["Pr(>F)"]]').to_ruby.first
best_rmse = rmse_means.select{|n,v| v == min_rmse}

R.eval "anova.r = aov(r_squared ~ experiments)"
r_squared_p = R.eval('summary(anova.r)[[1]][["Pr(>F)"]]').to_ruby.first
best_r_squared = r_squared_means.select{|n,v| v == max_r_squared}

significant_differences = {}
# ugly hack, because R.eval("TukeyHSD(anova.r)").to_ruby returns only the result matrix, but no comparison names
path = File.join File.expand_path(File.dirname(__FILE__)), "..", "results"

# print to file
file = File.join path, "r_squared.txt"
R.eval "sink('#{file}')"
R.eval "print(TukeyHSD(anova.r))"
R.eval "sink()"
significant_differences[:r_squared] = []
# read results
`sed '0,/p adj/d' #{file} `.each_line do |line|
  line.chomp!
  unless line.empty?
    comparison, p = line.split
    if p.to_f < 0.05
      comp = comparison.split("-")
      comp.delete(best_r_squared.keys.first)
      comp = ["BEST.#{best_r_squared.keys.first}"] + comp if comp.size ==1
      significant_differences[:r_squared] << { comp.join("-") => p.to_f }
    end
  end
end

# print to file
file = File.join path, "rmse.txt"
R.eval "sink('#{file}')"
R.eval "print(TukeyHSD(anova.rmse))"
R.eval "sink()"
significant_differences[:rmse] = []
# read results
`sed '0,/p adj/d' #{file} `.each_line do |line|
  line.chomp!
  unless line.empty?
    comparison, p = line.split
    if p.to_f < 0.05
      comp = comparison.split("-")
      comp.delete(best_rmse.keys.first)
      comp = ["BEST.#{best_rmse.keys.first}"] + comp if comp.size ==1
      significant_differences[:rmse] << { comp.join("-") => p.to_f }
    end
  end
end

File.open(File.join(RESULTS_DIR,"cv-comparison.json"),"w+") do |f|
  f.puts JSON.pretty_generate({
    :best_rmse => best_rmse,
    :best_r_squared => best_r_squared,
    :anova_rmse => rmse_p,
    :anova_r_squared => r_squared_p,
    :significant_differences => significant_differences,
  })
end
