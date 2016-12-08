#!/usr/bin/env ruby
require_relative "setup.rb"

enm_datasets = Dataset.all.select{|d| !d.name.match('Fold') and d.source.match('data.enanomapper.net')}

csv = "Dataset, Endpoint, Nanoparticles\n"
enm_datasets.each do |d|
  case d.name
  when /Protein Corona/
    d.name = "Protein Corona"
  when /MARINA/
    d.name = "MARINA"
  end
  if d.substances.size > 1
    nr = {}
    d.features.each do |f|
      #p f.source, f.name
      if d.name.match "MODENA"
        case f.source
        when /BAO_0003009/
          f.name = "Cell Viability Assay"
        when /BAO_0010001/
          f.name = "ATP Assay"
        when /NPO_1709/
          f.name = "LDH Release Assay"
        when /NPO_1911/
          f.name = "MTT Assay"
        end
      end
     count = 0
     d.substances.each{|s| count += 1 if d.values(s,f)}
     nr[f.name] ||= []
     nr[f.name] << count
    end
    nr.each do |name,counts|
      name = "TNF-alpha" if name.match "TNF" # fix encoding
      csv += "#{d.name}, #{name.gsub("_"," ")}, #{counts.max}\n"
    end
  end
end

File.open(File.join(RESULTS_DIR,"substances-per-endpoint.csv"),"w+"){ |f| f.puts csv }
