#!/usr/bin/env ruby

require File.expand_path(File.join(File.dirname(__FILE__), "run_common.rb"))

demo("solve_by_parameter5(ruby lib/trips5.rb example)") do
  solve_by_parameter5(["example"])
end
