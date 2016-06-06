require_relative "setup.rb"

repeated_cvs = JSON.parse(File.join(RESULTS_DIR,"repeated-crossvalidations.json"))
puts repeated_cvs[ARGV[0]][ARGV[1]].collect{|cv| cv[ARGV[3]]}.join(", ")
