#!/usr/bin/env ruby

# trips.rb - Triangle Puzzle Solver
#   by takehikom

# inspired by:
# http://www.huffingtonpost.jp/satoshi-kagimoto/triangle-puzzle_b_5590269.html

# ruby trips.rb
# ruby -d trips.rb
# ruby trips.rb example
# ruby trips.rb 10,7,7,9,7,11
# ruby trips.rb 10,7,,9,7,11 ,,,2

module TrianglePuzzle
  SEQ = (1..5).to_a

  class Table
    def initialize(ary)
      @array = ary.dup
    end
    attr_accessor :array

    def to_s(flag_sum = false)
      lines = []
      lines << "   #{@array[9]}"
      lines << "  #{@array[7]} #{@array[8]}"
      lines << " #{@array[4]} #{@array[5]} #{@array[6]}"
      lines << "#{@array[0]} #{@array[1]} #{@array[2]} #{@array[3]}"

      if flag_sum
        a = get_sums
        lines << "left<1>  = #{a.shift}"
        lines << "left<2>  = #{a.shift}"
        lines << "down<1>  = #{a.shift}"
        lines << "down<2>  = #{a.shift}"
        lines << "right<1> = #{a.shift}"
        lines << "right<2> = #{a.shift}"
      end

      lines.join("\n")
    end

    def print_table(flag_sum = false)
      puts to_s(flag_sum)
    end

    def get_sums
      [@array[7] + @array[8],
        @array[4] + @array[5] + @array[6],
        @array[1] + @array[4],
        @array[2] + @array[5] + @array[7],
        @array[6] + @array[2],
        @array[8] + @array[5] + @array[1]]
    end
    alias :sums :get_sums

    def valid?(flag_msg = false)
      if @array.length != 10
        flag_msg ? "wrong size" : false
      elsif @array.map {|item| TrianglePuzzle::SEQ.index(item).nil?}.uniq != [false]
        flag_msg ? "invalid value" : false
      elsif @array.values_at(0, 1, 2, 3, 5).sort != TrianglePuzzle::SEQ ||
          @array.values_at(0, 4, 5, 7, 9).sort != TrianglePuzzle::SEQ ||
          @array.values_at(3, 5, 6, 8, 9).sort != TrianglePuzzle::SEQ
        flag_msg ? "wrong permutation" : false
      else
        flag_msg ? "OK" : true
      end
    end
  end

  class Searcher
    def initialize; end
    attr_reader :all, :hash

    def start(flag_print = false)
      @all = []
      @hash = Hash.new
      tab_cnt = 0

      TrianglePuzzle::SEQ.permutation do |a|
        ary = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        ary[0] = a[0]
        ary[1] = a[1]
        ary[2] = a[2]
        ary[3] = a[3]
        ary[5] = a[4]

        (TrianglePuzzle::SEQ - [ary[0], ary[3], ary[5]]).each do |b|
          ary[9] = b

          (TrianglePuzzle::SEQ - [ary[0], ary[5], ary[9]]).permutation do |c|
            ary[4] = c[0]
            ary[7] = c[1]

            (TrianglePuzzle::SEQ - [ary[3], ary[5], ary[9]]).permutation do |d|
              ary[6] = d[0]
              ary[8] = d[1]

              tab = TrianglePuzzle::Table.new(ary)
              # tab.valid? || raise

              tab_cnt += 1
              if flag_print
                puts "==== Table #{tab_cnt} ===="
                tab.print_table
                puts "sums: #{tab.get_sums.join(', ')}"
                puts
              end
              @all << ary
              k = tab.get_sums.join(",")
              if @hash.key?(k)
                @hash[k] << tab
              else
                @hash[k] = [tab]
              end
            end
          end
        end
      end
    end
  end

  class Solver
    def initialize(param = {})
      @answer = []
      @place_init = param[:place] || [nil] * 10
      @sums = (param[:sums] || [nil] * 6).values_at(0..5)
      if param[:topdown]
        @place_init = @place_init.values_at(6, 7, 8, 9, 3, 4, 5, 1, 2, 0)
      end
    end
    attr_reader :answer
    attr_accessor :array_init, :sums

    def solve
      TrianglePuzzle::SEQ.permutation(1) do |a1|
        ary = [nil] * 10

        next if !@place_init[5].nil? && a1.first != @place_init[5]
        ary[5] = a1.shift

        (TrianglePuzzle::SEQ - [ary[5]]).permutation(3) do |a2|
          next if !@place_init[0].nil? && a2.first != @place_init[0]
          ary[0] = a2.shift
          next if !@place_init[3].nil? && a2.first != @place_init[3]
          ary[3] = a2.shift
          next if !@place_init[9].nil? && a2.first != @place_init[9]
          ary[9] = a2.shift

          (TrianglePuzzle::SEQ - [ary[0], ary[3], ary[5]]).permutation(2) do |a3|
            next if !@place_init[1].nil? && a3.first != @place_init[1]
            ary[1] = a3.shift
            next if !@place_init[2].nil? && a3.first != @place_init[2]
            ary[2] = a3.shift

            (TrianglePuzzle::SEQ - [ary[0], ary[5], ary[9]]).permutation(2) do |a4|
              next if !@place_init[4].nil? && a4.first != @place_init[4]
              ary[4] = a4.shift
              next if !@place_init[7].nil? && a4.first != @place_init[7]
              ary[7] = a4.shift

              (TrianglePuzzle::SEQ - [ary[3], ary[5], ary[9]]).permutation(2) do |a5|
                next if !@place_init[6].nil? && a5.first != @place_init[6]
                ary[6] = a5.shift
                next if !@place_init[8].nil? && a5.first != @place_init[8]
                ary[8] = a5.shift

                tab = TrianglePuzzle::Table.new(ary)
                next if !tab.valid?
                next if tab.sums.zip(@sums).map {|item| item[1].nil? || item[0] == item[1]}.uniq != [true]

                @answer << tab
              end
            end
          end
        end
      end
    end
    alias :start :solve

    def to_s
      return "no answer" if @answer.empty?

      line = []
      @answer.each_with_index do |tab, i|
        line << "\##{i + 1}" if line.length > 1
        line << tab.to_s + "\n"
      end
      line.join("\n")
    end

    def initial_condition(flag_place = false, any_symbol = "*")
      s = @sums.map{|item| item || any_symbol}.join(",")
      if flag_place || @place_init.uniq != [nil]
        s += " (" + @place_init.values_at(9, 7, 8, 4, 5, 6, 0, 1, 2, 3).map{|item| item || any_symbol}.join(",") + ")"
      end

      s
    end
  end
end

if __FILE__ == $0
  if !ARGV.nil?
    $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
    require "helper.rb"

    solve_by_parameter
  end
end
