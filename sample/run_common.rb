#!/usr/bin/env ruby

# usage:
# require File.expand_path(File.join(File.dirname(__FILE__), "run_common.rb"))

lib_dir = File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
$LOAD_PATH.unshift(lib_dir)

require "trips.rb"
require "trips5.rb"
require "helper.rb"
include TrianglePuzzle::Helper
