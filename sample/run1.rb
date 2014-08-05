#!/usr/bin/env ruby

lib_dir = File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
# sample_dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(lib_dir)
# $LOAD_PATH.unshift(sample_dir)

require "trips.rb"
require "trips5.rb"
require "helper.rb"
include TrianglePuzzle::Helper

demo("sample_searcher") do
  sample_searcher
end

[["example"], ["10,7,7,9,7,11"], ["10,7,,9,7,11", ",,,2"]].each do |param|
  demo("solve_by_parameter(ruby lib/trips.rb #{param.join(' ')})") do
    solve_by_parameter(param)
  end
end

demo("solve_by_parameter5(ruby lib/trips5.rb example)") do
  solve_by_parameter5(["example"])
end
