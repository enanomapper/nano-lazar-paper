#!/usr/bin/env ruby
require_relative 'setup.rb'
data_dir = File.join(File.dirname(__FILE__),"..","data")
FileUtils.mkdir_p data_dir
Import::Enanomapper.mirror data_dir
