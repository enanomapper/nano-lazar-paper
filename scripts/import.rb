require_relative "setup.rb"
#$mongo.database.drop
#$gridfs = $mongo.database.fs
#Import::Enanomapper.import File.join(File.dirname(__FILE__),"..","data")
training_dataset = Dataset.find_or_create_by(:name => "Protein Corona Fingerprinting Predicts the Cellular Interaction of Gold and Silver Nanoparticles")
File.open(File.join(RESULTS_DIR,"training-dataset.id"),"w+"){|f| f.puts training_dataset.id}
