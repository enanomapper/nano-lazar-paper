#!/usr/bin/env ruby
require 'json'
repeated_cvs = JSON.parse(File.read(File.join("results","repeated-crossvalidations.json")))
cvs = repeated_cvs[ARGV[0]][ARGV[1]]["cvs"]
puts cvs.collect{|cv| cv[ARGV[2]].round(2)}.join(", ")
