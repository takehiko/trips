#!/usr/bin/env ruby

require File.expand_path(File.join(File.dirname(__FILE__), "run_common.rb"))

s_str = "7,11,23,5,20,15,8,17,14"
[ "3,,,6,,4,,8,7,,4,,,,5",
  "3,,,6,,4,,8,7,,4",
  "3,,,6,,4,,8,7",
  "3,,,6,,4,,8",
  "3,,,6,,4",
  "3,,,6",
  "3",
  ""
].each do |p_str|
  next if ARGV.first && p_str.length <= 5
  demo("solve_by_parameter5(ruby lib/trips5.rb #{s_str} #{p_str})") do
    t1 = Time.new
    solve_by_parameter5([s_str, p_str])
    t2 = Time.new
    puts "#{t2 - t1} sec."
  end
end
