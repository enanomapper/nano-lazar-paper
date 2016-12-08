#!/usr/bin/env ruby

require 'pandoc-filter'

PandocFilter.filter do |type,value,format,meta|
  if type == "Code"
    code = value.last if value.is_a? Array
    if code.match(/^!/)
      PandocElement.Code(["",[],[]],`#{code}`)
    elsif code.match(/^include/)
  #p type,value,format,meta
      file = code.sub(/^include/,'').strip
      tab = File.read file
      #PandocElement.Code(["",[],[]],tab)
      PandocElement.Table(["",[],[]],tab)
      #PandocElement.Table(tab)
    end
  end
end
