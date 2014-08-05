#!/usr/bin/env ruby

# trips5.rb - Trinagle Puzzle Solver (5 numbers on a side)
#   by takehikom

# inspired by:
# http://www.ksproj.com/PDF/chirashi201405.pdf
# see also:
# https://gist.github.com/takehiko/65dc59fb984e60bafb24 (trips.rb)

# ruby trips5.rb
# ruby -d trips5.rb
# ruby trips5.rb example
# ruby trips5.rb 7,11,23,5,20,15,8,17,14 3,,,6,,4,,8,7,,4,,,,5
# ruby trips5.rb 7,11,23,5,20,15,8,17,14

# NOTE: Since we get 4354560 patterns (whereas trips.rb outputs
# just 960 patterns), it may take several minutes to finish
# "ruby trips5.rb", and you will have gigabytes of
# text file after executing "ruby -d trips5.rb"
# to capture the output.

module TrianglePuzzle
  module Five; end
end

module TrianglePuzzle::Five
  SEQ = (1..8).to_a

  class Table
    def initialize(ary)
      @array = ary.dup
    end
    attr_accessor :array

    def to_s(flag_sum = false)
      lines = []
      lines << "    #{@array[14]}"
      lines << "   #{@array[12]} #{@array[13]}"
      lines << "  #{@array[9]} #{@array[10]} #{@array[11]}"
      lines << " #{@array[5]} #{@array[6]} #{@array[7]} #{@array[8]}"
      lines << "#{@array[0]} #{@array[1]} #{@array[2]} #{@array[3]} #{@array[4]}"

      if flag_sum
        a = get_nine_sums
        lines << "left<1>  = #{a.shift}"
        lines << "left<2>  = #{a.shift}"
        lines << "left<3>  = #{a.shift}"
        lines << "down<1>  = #{a.shift}"
        lines << "down<2>  = #{a.shift}"
        lines << "down<3>  = #{a.shift}"
        lines << "right<1> = #{a.shift}"
        lines << "right<2> = #{a.shift}"
        lines << "right<3> = #{a.shift}"
      end

      lines.join("\n")
    end

    def print_table(flag_sum = false)
      puts to_s(flag_sum)
    end

    def get_sums
      [@array[12]  + @array[13],
        @array[9]  + @array[10] + @array[11],
        @array[5]  + @array[6]  + @array[7]  + @array[8],
        @array[1]  + @array[5],
        @array[2]  + @array[6]  + @array[9],
        @array[3]  + @array[7]  + @array[10] + @array[12],
        @array[8]  + @array[3],
        @array[11] + @array[7]  + @array[2],
        @array[13] + @array[10] + @array[6]  + @array[1]]
    end
    alias :sums :get_sums

    def valid?(flag_msg = false)
      if @array.length != 15
        flag_msg ? "wrong size" : false
      elsif @array.map {|item| TrianglePuzzle::Five::SEQ.index(item).nil?}.uniq != [false]
        flag_msg ? "invalid value" : false
      elsif @array.values_at(0, 1, 2, 3, 4, 6, 7, 10).sort != TrianglePuzzle::Five::SEQ ||
          @array.values_at(0, 5, 9, 12, 14, 6, 7, 10).sort != TrianglePuzzle::Five::SEQ ||
          @array.values_at(4, 8, 11, 13, 14, 6, 7, 10).sort != TrianglePuzzle::Five::SEQ
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
      ary_zero = [0] * 15

      TrianglePuzzle::Five::SEQ.permutation do |a|
        ary = ary_zero.dup
        ary[0] = a[0]
        ary[1] = a[1]
        ary[2] = a[2]
        ary[3] = a[3]
        ary[4] = a[4]
        ary[6] = a[5]
        ary[7] = a[6]
        ary[10] = a[7]

        (TrianglePuzzle::Five::SEQ - ary.values_at(0, 4, 6, 7, 10)).each do |b|
          ary[14] = b

          (TrianglePuzzle::Five::SEQ - ary.values_at(0, 14, 6, 7, 10)).permutation do |c|
            ary[5] = c[0]
            ary[9] = c[1]
            ary[12] = c[2]

            (TrianglePuzzle::Five::SEQ - ary.values_at(4, 14, 6, 7, 10)).permutation do |d|
              ary[8] = d[0]
              ary[11] = d[1]
              ary[13] = d[2]

              tab = TrianglePuzzle::Five::Table.new(ary)

              tab_cnt += 1
              if flag_print
                puts "==== Table #{tab_cnt} ===="
                tab.print_table
                puts "sums: #{tab.sums.join(', ')}"
                puts
              end

              if !tab.valid?
                puts "==== Table #{tab_cnt} ===="
                tab.print_table
                puts tab.valid?(true)
                raise
              end

              @all << ary
              k = tab.sums.join(",")
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
      @place_init = param[:place] || [nil] * 15
      @sums = (param[:sums] || [nil] * 9).values_at(0..8)
      if param[:topdown]
        @place_init = @place_init.values_at(10, 11, 12, 13, 14, 6, 7, 8, 9, 3, 4, 5, 1, 2, 0)
      end
    end
    attr_reader :answer
    attr_accessor :array_init, :sums

    def solve
      TrianglePuzzle::Five::SEQ.permutation(3) do |a1|
        ary = [nil] * 15

        next if !@place_init[6].nil? && a1[0] != @place_init[6]
        ary[6] = a1[0]
        next if !@place_init[7].nil? && a1[1] != @place_init[7]
        ary[7] = a1[1]
        next if !@place_init[10].nil? && a1[2] != @place_init[10]
        ary[10] = a1[2]

        (TrianglePuzzle::Five::SEQ - a1).permutation(3) do |a2|
          next if !@place_init[0].nil? && a2.first != @place_init[0]
          ary[0] = a2.shift
          next if !@place_init[4].nil? && a2.first != @place_init[4]
          ary[4] = a2.shift
          next if !@place_init[14].nil? && a2.first != @place_init[14]
          ary[14] = a2.shift

          (TrianglePuzzle::Five::SEQ - ary.values_at(0, 4, 6, 7, 10)).permutation(3) do |a3|
            next if !@place_init[1].nil? && a3.first != @place_init[1]
            ary[1] = a3.shift
            next if !@place_init[2].nil? && a3.first != @place_init[2]
            ary[2] = a3.shift
            next if !@place_init[3].nil? && a3.first != @place_init[3]
            ary[3] = a3.shift

            (TrianglePuzzle::Five::SEQ - ary.values_at(0, 14, 6, 7, 10)).permutation(3) do |a4|
              next if !@place_init[5].nil? && a4.first != @place_init[5]
              ary[5] = a4.shift
              next if !@place_init[9].nil? && a4.first != @place_init[9]
              ary[9] = a4.shift
              next if !@place_init[12].nil? && a4.first != @place_init[12]
              ary[12] = a4.shift

              (TrianglePuzzle::Five::SEQ - ary.values_at(4, 14, 6, 7, 10)).permutation(3) do |a5|
                next if !@place_init[8].nil? && a5.first != @place_init[8]
                ary[8] = a5.shift
                next if !@place_init[11].nil? && a5.first != @place_init[11]
                ary[11] = a5.shift
                next if !@place_init[13].nil? && a5.first != @place_init[13]
                ary[13] = a5.shift

                tab = TrianglePuzzle::Five::Table.new(ary)
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
        s += " (" + @place_init.values_at(14, 12, 13, 9, 10, 11, 5, 6, 7, 8, 0, 1, 2, 3, 4).map{|item| item || any_symbol}.join(",") + ")"
      end

      s
    end
  end
end

if __FILE__ == $0
  if !ARGV.nil?
    $LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
    require "helper.rb"
    include TrianglePuzzle::Helper

    solve_by_parameter5
  end
end
