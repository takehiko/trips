#!/usr/bin/env ruby

Dir.glob(__FILE__.sub(/.rb$/, "_*.rb")) do |filename|
  puts filename if $DEBUG
  load File.expand_path(filename)
end
