require_relative "setup.rb"

format = ARGV[2]
format ||= "pdf"
repeated_cvs = JSON.parse(File.read(File.join(RESULTS_DIR,"repeated-crossvalidations.json")))
repeated_cv = Validation::RepeatedCrossValidation.find(repeated_cvs[ARGV[0]][ARGV[1]]["id"])
file = File.join(FIG_DIR,"#{ARGV[0]}-#{ARGV[1].downcase.gsub("-",'')}-crossvalidations.#{format}")
File.open(file,"w+"){|f| f.puts repeated_cv.correlation_plot(format: format)}
