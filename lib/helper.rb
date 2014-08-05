#!/usr/bin/env ruby

require "open3"

module TrianglePuzzle
  module Helper; end
end

module TrianglePuzzle::Helper
  def nums_to_a(s, limit = nil)
    a = s.split(/[,;]/).map {|item| /^\s*\d+/ =~ item ? item.to_i : nil}
    if Integer === limit
      a = a.values_at(Range.new(0, limit, true))
    end

    a
  end

  def solve_by_parameter(param = ARGV)
    if /exam/ =~ param[0]
      solve_examples
      return
    end

    sums = nums_to_a(param.shift, 6)
    if param[0]
      place = nums_to_a(param.shift, 10)
    else
      place = nil
    end
    sol = TrianglePuzzle::Solver.new(:place => place,
                                     :sums => sums,
                                     :topdown => true)
    sol.start
    puts "==== #{sol.initial_condition} / Solver ===="
    puts sol
  end

  def sample_searcher
    s = TrianglePuzzle::Searcher.new
    s.start($DEBUG)

    if $DEBUG
      h = s.hash
      h.keys.sort_by {|item| item.split(/,/).map {|num| num.to_i}}.each do |k|
        puts "====== values=#{k} ======"
        h[k].each_with_index do |tab, i|
          puts "(case #{i + 1})"
          tab.print_table(true)
        end
        puts
      end
    end

    sums = "10,7,7,9,7,11"
    puts "==== #{sums} / Searcher ===="
    s.hash[sums].each do |tab|
      tab.print_table(true)
    end
    puts

    sums = "6,11,6,8,7,6"
    puts "==== #{sums} / Searcher ===="
    s.hash[sums].each do |tab|
      tab.print_table(true)
    end
    # puts
  end

  def solve_examples
    place = nil
    # place = []; place[5] = 1
    # place = []; place[5] = 2
    sums = [10, 7, 7, 9, 7, 11]
    sol = TrianglePuzzle::Solver.new(:place => place, :sums => sums, :topdown => true)
    sol.start
    puts "==== #{sol.initial_condition} / Solver ===="
    puts sol
    puts
    sums = [6, 11, 6, 8, 7, 6]
    sol = TrianglePuzzle::Solver.new(:place => place, :sums => sums, :topdown => true)
    sol.start
    puts "==== #{sol.initial_condition} / Solver ===="
    puts sol
  end

  def solve_by_parameter5(param = ARGV)
    if /exam/ =~ param[0]
      solve_example5
      return
    end

    sums = nums_to_a(param.shift, 9)
    if param[0]
      place = nums_to_a(param.shift, 15)
    else
      place = nil
    end
    sol = TrianglePuzzle::Five::Solver.new(:place => place, :sums => sums, :topdown => true)
    sol.start
    puts "==== #{sol.initial_condition} / Solver ===="
    puts sol
  end

  def sample_searcher5
    s = TrianglePuzzle::Five::Searcher.new
    s.start($DEBUG)

    if $DEBUG
      h = s.hash
      h.keys.sort_by {|item| item.split(/,/).map {|num| num.to_i}}.each do |k|
        puts "====== values=#{k} ======"
        h[k].each_with_index do |tab, i|
          puts "(case #{i + 1})"
          tab.print_table
        end
        puts
      end
    end

    puts "==== 7,11,23,5,20,15,8,17,14 ===="
    s.hash["7,11,23,5,20,15,8,17,14"].each do |tab|
      tab.print_table(true)
    end
    puts
  end

  def solve_example5
    place = [3, nil, nil, 6, nil, 4, nil, 8, 7, nil, 4, nil, nil, nil, 5]
    sums = [7, 11, 23, 5, 20, 15, 8, 17, 14]
    sol = TrianglePuzzle::Five::Solver.new(:place => place, :sums => sums, :topdown => true)
    sol.start
    puts "==== #{sol.initial_condition} / Solver ===="
    puts sol
    puts
    exit
  end

  def exist_bin?(command)
    result = Open3.capture3("which #{command}")

    return false if result.first.empty?
    return true if test(?f, result.first.chomp)
    false
  end

  def examine_dependency(param = nil)
    h = {}

    ["convert", "ffmpeg"].each do |command|
      h[command.to_sym] = exist_bin?(command)
    end

    h[:font] = false
    if h[:convert]
      result = Open3.capture3("convert -debug annotate xc: -font #{Hash === param && param[:font] ? param[:font] : 'Liberation-Sans-Regular'} -pointsize 24 -annotate 0 'Test' null:")
      h[:font] = true if result[1].index("@ error").nil?
    end

    h
  end

  def dependency_ready?(*param)
    dep = examine_dependency
    param = dep.keys if param.empty?

    if param.include?(:convert) && !dep[:convert]
      puts "\'convert\' command is not available."
      return false
    elsif param.include?(:font) && !dep[:font]
      puts "Font is not ready."
      return false
    elsif param.include?(:ffmpeg) && !dep[:ffmpeg]
      puts "\'ffmpeg\' command is not available."
      return false
    end

    true
  end

  def demo(msg = "")
    if !msg.empty?
      puts "****** #{msg} ******"
    end
    if block_given?
      yield
      puts
    end
  end
end
