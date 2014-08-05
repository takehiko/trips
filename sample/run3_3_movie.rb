#!/usr/bin/env ruby

require File.expand_path(File.join(File.dirname(__FILE__), "run_common.rb"))

demo("movie") do
  require "movie.rb"
end
