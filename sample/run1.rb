#!/usr/bin/env ruby

lib_dir = File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
# sample_dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(lib_dir)
# $LOAD_PATH.unshift(sample_dir)

require "trips.rb"
require "trips5.rb"
require "helper.rb"

puts "****** sample_searcher ******"
sample_searcher

[["example"], ["10,7,7,9,7,11"], ["10,7,,9,7,11", ",,,2"]].each do |param|
  puts
  puts "****** solve_by_parameter(ruby lib/trips.rb #{param.join(' ')}) ******"
  solve_by_parameter(param)
end

puts
puts "****** solve_by_parameter5(ruby lib/trips5.rb example) ******"
solve_by_parameter5(["example"])
