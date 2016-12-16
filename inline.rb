#!/usr/bin/env ruby

require 'pandoc-filter'
require "paru/filter"

Paru::Filter.run do 
  # Code seems to be broken in pandoc-filter and paru/filter (or pandoc itself)
  with "Span" do |code|
    code = `code.inner_markdown`
    #p code
  end

end
=begin
    if code.match(/^!/)

converter = Paru::Pandoc.new
PandocFilter.filter do |type,value,format,meta|
  if type == "Code"
    code = value.last if value.is_a? Array
    if code.match(/^!/)
      PandocElement.Code(["",[],[]],`#{code}`)
    end
  end
end
=end
