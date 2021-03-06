require 'erb'
require 'json'
require "maruku"
require "pp"

puts "Run: #{__FILE__}"

# load ordered category list
table_config = JSON.parse(File.read("#{File.dirname(__FILE__)}/../config/categories.json"))

data_grouped_by_category = {}

puts "Config succesfully loaded."

# iterate on data files (alphabetically ordered)
Dir.glob("#{File.dirname(__FILE__)}/../projects-data/*.json").sort.each do |file|

  # read content
  data = JSON.parse(File.read(file))
  data_grouped_by_category[data["category"]] ||= []

  data_grouped_by_category[data["category"]] << data
end

puts "Projects Data succesfully loaded."

# create table content
categories = []
table_config["categories"].each do |c|
  categories << {"name" => c, "items" => data_grouped_by_category[c]}
end

puts "Projects Data succesfully grouped."

papers = {}

Dir.glob("#{File.dirname(__FILE__)}/../papers-data/*.json").sort.each do |file|
  # read content
  data = JSON.parse(File.read(file))
  papers[data["year"]] ||= []
  papers[data["year"]] << data
end

puts "Paper Data succesfully loaded."

# write result
File.open("#{File.dirname(__FILE__)}/../public/githubreadme.md", 'w') { |file| file.write(ERB.new(File.read("#{File.dirname(__FILE__)}/templates/githubreadme.md"), nil, '-').result(binding)) } 

puts "Destination file written."