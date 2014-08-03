#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__))
require "trips.rb"
require "image.rb"

dir = "p"
command = test(?d, dir) ? "rm #{dir}/*" : "mkdir #{dir}"
puts command
system command

s = TrianglePuzzle::Searcher.new
s.start
cnt = 0
r = [10, 20, 50] + (1..9).to_a.map {|i| i * 100} + [960]
h = s.hash
h.keys.sort_by {|item| item.split(/,/).map {|num| num.to_i}}.each do |k|
  h[k].each_with_index do |tab, i|
    cnt += 1
    numbers = tab.array.values_at(9, 7, 8, 4, 5, 6, 0, 1, 2, 3)
    sums = tab.sums
    TrianglePuzzleDrawer.new(:caption => "\##{cnt}",
                             :numbers => numbers,
                             :sums => sums,
                             :side => 200,
                             :filename => "%s/%03d.png" % [dir, cnt]).start
    if r.include?(cnt)
      puts "made table \##{cnt}"
    end
  end
end

command = "convert -geometry 200x200 -delay 50 -loop 0 -colors 32 #{dir}/*.png trips_all.gif"
puts command
system command
