ENV["LAZAR_ENV"] = "development"
require_relative '../../lazar/lib/lazar.rb'
include OpenTox
RESULTS_DIR = File.join(File.dirname(__FILE__),"..","results")
FIG_DIR = File.join(File.dirname(__FILE__),"..","figures")
