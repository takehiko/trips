#!/usr/bin/env ruby

puts "CAUTION: This script may spend a lot of time."

Dir.glob(__FILE__.sub(/.rb$/, "_*.rb")) do |filename|
  puts filename if $DEBUG
  load File.expand_path(filename)
end
