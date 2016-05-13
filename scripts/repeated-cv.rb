require_relative "setup.rb"

experiment = ARGV[0]

repeated_cv_id = File.read(File.join(RESULTS_DIR,"#{experiment}-repeated-crossvalidation.id")).chomp
cv = CrossValidation.find repeated_cv_id
p cv
p cv.predictions.size
File.open(File.join(RESULTS_DIR,"#{experiment}-cv#{1}.png"),"w+"){|f| f.print cv.correlation_plot}
=begin
properties = [:r_squared,:rmse,:mae]
cvs = repeated_cv.crossvalidations
properties.each do |property|
  result = cvs.collect { |cv| cv.send(property).round(2) }
  File.open(File.join(RESULTS_DIR,"#{experiment}.#{property}"),"w+"){|f| f.print result.join(", ")}
end
cvs.each_with_index do |cv,i|
  p cv.predictions
  p cv.statistics
  #p cv.nr_instances
      cv.validations.each do |validation|
        p validation.nr_instances
        p validation.nr_unpredicted
        p validation.predictions.size
        #predictions.merge! validation.predictions
      end
  #p cv.predictions.size
  File.open(File.join(RESULTS_DIR,"#{experiment}-cv#{i}.png"),"w+"){|f| f.print cv.correlation_plot}
end
=end
