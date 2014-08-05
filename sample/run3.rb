#!/usr/bin/env ruby

if ARGV.first != "execute"
  puts "run \"ruby #{$PROGRAM_NAME} execute\""
  puts "(The command will spend a lot of time and disk space.)"
  exit
end

lib_dir = File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
$LOAD_PATH.unshift(lib_dir)

require "trips.rb"
require "trips5.rb"
require "helper.rb"
include TrianglePuzzle::Helper

puts "****** sample_searcher5 ******"
sample_searcher5

puts
puts "****** animation ******"
require "animation.rb"

puts
puts "****** movie ******"
require "movie.rb"
