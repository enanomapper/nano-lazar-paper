ENV["LAZAR_ENV"] = "development"
require_relative '../../lazar/lib/lazar.rb'
include OpenTox
$mongo.database.drop
$gridfs = $mongo.database.fs
