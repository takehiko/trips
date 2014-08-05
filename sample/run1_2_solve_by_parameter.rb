#!/usr/bin/env ruby

require File.expand_path(File.join(File.dirname(__FILE__), "run_common.rb"))

[["example"], ["10,7,7,9,7,11"], ["10,7,,9,7,11", ",,,2"]].each do |param|
  demo("solve_by_parameter(ruby lib/trips.rb #{param.join(' ')})") do
    solve_by_parameter(param)
  end
end
