#!/usr/bin/env ruby

require 'test/unit'

lib_dir = File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
$LOAD_PATH.unshift(lib_dir)
require "trips.rb"

class TestTrips < Test::Unit::TestCase
  def test_searcher
    s = TrianglePuzzle::Searcher.new
    s.start

    assert_equal(960, s.all.length)

    a = s.hash["10,7,7,9,7,11"]
    assert_equal(1, a.length)
    assert_equal([4, 5, 3, 2, 2, 1, 4, 5, 5, 3], a.first.array)
  end
end
