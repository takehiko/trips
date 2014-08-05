#!/usr/bin/env ruby

require File.expand_path(File.join(File.dirname(__FILE__), "run_common.rb"))

if !dependency_ready?(:convert, :font, :ffmpeg)
  demo("movie.rb") do
    puts "aborted"
  end
else
  demo("movie") do
    require "movie.rb"
  end
end
