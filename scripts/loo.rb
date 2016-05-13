require_relative "setup.rb"
cv = LeaveOneOutValidation.find `cat results/weighted-average-loo.id`.chomp
p cv
p cv.predictions.size
File.open(File.join(RESULTS_DIR,"loo-cv.png"),"w+"){|f| f.print cv.correlation_plot}

