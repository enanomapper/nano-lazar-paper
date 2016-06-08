#!/usr/bin/env ruby

require 'pandoc-filter'

PandocFilter.filter do |type,value,format,meta|
  if type == "Code"
    code = value.last if value.is_a? Array
    if code.match(/^!/)
      PandocElement.Code(["",[],[]],`#{code}`)
    end
  end
end
