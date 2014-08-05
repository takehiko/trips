#!/usr/bin/env ruby

if ARGV.first != "execute"
  puts "run \"ruby #{$PROGRAM_NAME} execute\""
  puts "(The command will spend a lot of time and disk space.)"
  exit
end

Dir.glob(__FILE__.sub(/.rb$/, "_*.rb")) do |filename|
  puts filename if $DEBUG
  load File.expand_path(filename)
end
