require_relative "setup.rb"

repeated_cvs = JSON.parse(File.join(RESULTS_DIR,"repeated-crossvalidations.json"))
repeated_cv = RepeatedCrossValidation.find(repeated_cvs[ARGV[0]][ARGV[1]].keys.first)
file = File.join(FIG_DIR,"#{ARGV[0]}-#{ARGV[1].downcase.gsub("-",'')}-crossvalidations.pdf")
File.open(file,"w+"){|f| f.puts repeated_cv.plot("pdf")}
