require_relative "setup.rb"

enm_datasets = Dataset.all.select{|d| !d.name.match('Fold') and d.source.match('data.enanomapper.net')}

datasets = enm_datasets.collect do |d|
   if d.substances.size > 1
     summary = {
      :dataset => d.name,
      :uri => d.source,
      :nr_substances => d.substances.size,
     }
     features = {}
     d.features.each do |f|
       count = 0
       d.substances.each{|s| count += 1 if d.values(s,f)}
       features[f.name] = count
     end
     summary[:substances_per_endpoint] = features
     summary
   end
end.compact

File.open(File.join(RESULTS_DIR,"substances-per-endpoint.json"),"w+"){ |f| f.puts JSON.pretty_generate(datasets) }
