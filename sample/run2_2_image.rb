#!/usr/bin/env ruby

require File.expand_path(File.join(File.dirname(__FILE__), "run_common.rb"))
require "image.rb"

q_a = [10, 7, 7, 9, 7, 11]
sol = TrianglePuzzle::Solver.new(:sums => q_a)
sol.start
p_a = sol.answer.first.array.values_at(9, 7, 8, 4, 5, 6, 0, 1, 2, 3)

demo("image.rb (sample_q.png)") do
  TrianglePuzzleDrawer.new(:caption => "Sample Question",
                           :numbers => [],
                           :sums => q_a,
                           :filename => "sample_q.png").start
end

demo("image.rb (sample_a.png)") do
  TrianglePuzzleDrawer.new(:caption => "Sample Answer",
                           :numbers => p_a,
                           :sums => q_a,
                           :filename => "sample_a.png").start
end
