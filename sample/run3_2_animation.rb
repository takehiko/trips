#!/usr/bin/env ruby

require File.expand_path(File.join(File.dirname(__FILE__), "run_common.rb"))

if !dependency_ready?(:convert, :font)
  demo("animation.rb") do
    puts "aborted"
  end
else
  demo("animation.rb") do
    require "animation.rb"
  end
end
