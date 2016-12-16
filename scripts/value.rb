#!/usr/bin/env ruby
require 'json'

file = ARGV[0]
param = ARGV[1]
data = JSON.parse(File.read(file))
print data[param]
