#!/usr/bin/env ruby
require_relative "setup.rb"

#puts JSON.pretty_generate(Feature.all.select{|f| f.category == "TOX"}.inspect)
#puts (Feature.all.select{|f| f.category == "TOX"}.collect{|f| f.source}.uniq)
enm_datasets = Dataset.all.select{|d| d.source and !d.name.match('Fold') and d.source.match('data.enanomapper.net')}

csv = "Dataset, Endpoint, Nanoparticles\n"
features = {}
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
      features[f] ||= 0
      if d.name.match "MODENA" # fix feature names
        #p d.substances.collect{|s| [s.core.name, s.coating.collect{|c| c.smiles}]}
=begin
        case f.source
        when /BAO_0003009/
          f.name = "Cell Viability Assay " + f.name
        when /BAO_0010001/
          f.name = "ATP Assay " + f.name
        when /NPO_1709/
          f.name = "LDH Release Assay " + f.name
        when /NPO_1911/
          f.name = "MTT Assay " + f.name
        end
=end
      end
     count = 0
     d.substances.each{|s| count += 1 if d.values(s,f)}
     d.substances.each{|s| features[f] += 1 if d.values(s,f)}
     nr[f.name] ||= []
     nr[f.name] << count
    end
    nr.each do |name,counts|
      name = "TNF-alpha" if name.match "TNF" # fix encoding
      csv += "#{d.name}, #{name.gsub("_"," ")}, #{counts.max}\n"
    end
  end
end

#p features.collect{|f,n| [f.name,n]}.compact.to_h
#File.open(File.join(RESULTS_DIR,"substances-per-endpoint.csv"),"w+"){ |f| f.puts csv }
