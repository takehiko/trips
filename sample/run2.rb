#!/usr/bin/env ruby

puts "CAUTION: This script may spend a lot of time."

lib_dir = File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
$LOAD_PATH.unshift(lib_dir)

require "trips.rb"
require "trips5.rb"
require "image.rb"
require "helper.rb"
include TrianglePuzzle::Helper

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
  puts
  puts "****** solve_by_parameter5(ruby lib/trips5.rb #{s_str} #{p_str}) ******"
  t1 = Time.new
  solve_by_parameter5([s_str, p_str])
  t2 = Time.new
  puts "#{t2 - t1} sec."
end

q_a = [10, 7, 7, 9, 7, 11]
sol = TrianglePuzzle::Solver.new(:sums => q_a)
sol.start
p_a = sol.answer.first.array.values_at(9, 7, 8, 4, 5, 6, 0, 1, 2, 3)

puts
puts "****** image.rb (q.png) ******"
TrianglePuzzleDrawer.new(:caption => "Sample Question",
                         :numbers => [],
                         :sums => q_a,
                         :filename => "image/q.png").start
puts
puts "****** image.rb (a.png) ******"
TrianglePuzzleDrawer.new(:caption => "Sample Answer",
                         :numbers => p_a,
                         :sums => q_a,
                         :filename => "image/a.png").start

