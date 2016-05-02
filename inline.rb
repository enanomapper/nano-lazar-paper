#!/usr/bin/env ruby

require 'pandoc-filter'

PandocFilter.filter do |type,value,format,meta|
  if type == "Code"
  code = value.last if value.is_a? Array
    if code.match(/^!/)
      PandocElement.Code(["",[],[]],`#{code}`)
    end
  end
#      value = [value.first,'"'+`#{code}`+'"']
#  exec type, value, format, meta
    #program = value.last.match(/{(.+)}/).to_s.gsub(/[{}]/,'')
    #code = value.last.split(/}\s+/,2).last
    #p value.size
    #p value
    #value[1] = `#{program} "#{code}"`.chomp
    #value[1] = "TEST"
    #p value
    #p program,code
#p value.last if type == "Code"
#  elsif type == "CodeBlock"
#    if value.first[1] == ["!"]
      #code = `#{code}`
#    end
#  end
end
=begin
=end
require 'json'
require 'yaml'

#doc = JSON.parse(`pandoc -t json -s nano-lazar.md`)
#puts doc.to_yaml
#doc.last.each{|s| p s}

#p PandocRuby.markdown(File.read("nano-lazar.md"))
