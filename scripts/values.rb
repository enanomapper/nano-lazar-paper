#!/usr/bin/env ruby
require 'json'

repeated_cvs = JSON.parse(File.read(File.join("results","repeated-crossvalidations.json")))
key = "#{ARGV[0]}.#{ARGV[1]}"
cvs = repeated_cvs[ARGV[0]][ARGV[1]]["cvs"]
cv_comparison = JSON.parse(File.read(File.join("results","cv-statistics.json")))
results = cvs.collect{|cv| cv[ARGV[2]].round(2)}.join(", ")
if cv_comparison["best_#{ARGV[2]}"][key]
  results = "#{results} **" 
elsif cv_comparison["significant_differences"][ARGV[2]].collect{|p| p.keys}.flatten.include?(key)
else
  results = "#{results} *" 
end
print results
