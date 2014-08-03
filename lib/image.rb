#!/usr/bin/env ruby

class TrianglePuzzleDrawer
  def initialize(opt = {})
    setup_by_param(opt)
    setup_coodinate
  end

  def setup_by_param(opt)
    @image_side = opt[:side] || 400
    @unit_len = opt[:unit] || (@image_side * 0.35)
    @place_r = opt[:numr] || (@unit_len * 0.25)
    @filename = opt[:filename] || "trips.png"
    @caption = opt[:caption]
    @places = opt[:numbers]
    @sums = opt[:sums]
    @flag_demo = opt[:demo]
    @bgcolor = opt[:bg] || "white"
    @flag_keep_center = opt[:keep_center]
  end

  def setup_coodinate
    @place_xy = []
    @sums_xy = []

    a1 = 1.0 / 4
    a2 = 2.0 / 3
    p1 = [a1, a1 + a2, a1 + a2 * 2].map {|ang|
        polar_canvas(1, ang)
    }
    p2 = [
      [ p1[0][0] * (2.0 / 3) + p1[1][0] * (1.0 / 3),
        p1[0][1] * (2.0 / 3) + p1[1][1] * (1.0 / 3) ],
      [ p1[0][0] * (1.0 / 3) + p1[1][0] * (2.0 / 3),
        p1[0][1] * (1.0 / 3) + p1[1][1] * (2.0 / 3) ],
      [ p1[1][0] * (2.0 / 3) + p1[2][0] * (1.0 / 3),
        p1[1][1] * (2.0 / 3) + p1[2][1] * (1.0 / 3) ],
      [ p1[1][0] * (1.0 / 3) + p1[2][0] * (2.0 / 3),
        p1[1][1] * (1.0 / 3) + p1[2][1] * (2.0 / 3) ],
      [ p1[2][0] * (2.0 / 3) + p1[0][0] * (1.0 / 3),
        p1[2][1] * (2.0 / 3) + p1[0][1] * (1.0 / 3) ],
      [ p1[2][0] * (1.0 / 3) + p1[0][0] * (2.0 / 3),
        p1[2][1] * (1.0 / 3) + p1[0][1] * (2.0 / 3) ]
    ]
    orig = xy_canvas(0, 0)

    @place_xy = [
      p1[0],
      p2[5], p2[0],
      p2[4], orig, p2[1],
      p1[2], p2[3], p2[2], p1[1]
    ]
    puts "@place_xy: " + @place_xy.inspect if $DEBUG

    d1 = [@place_xy[2][0] - @place_xy[1][0], 0]
    d2 = [@place_xy[1][0] - @place_xy[0][0], @place_xy[1][1] - @place_xy[0][1]]
    d3 = [@place_xy[2][0] - @place_xy[0][0], @place_xy[2][1] - @place_xy[0][1]]
    @sums_xy = [
      [@place_xy[1][0] - d1[0], @place_xy[1][1] - d1[1]],
      [@place_xy[3][0] - d1[0], @place_xy[3][1] - d1[1]],
      [@place_xy[7][0] + d3[0], @place_xy[7][1] + d3[1]],
      [@place_xy[8][0] + d3[0], @place_xy[8][1] + d3[1]],
      [@place_xy[5][0] - d2[0], @place_xy[5][1] - d2[1]],
      [@place_xy[2][0] - d2[0], @place_xy[2][1] - d2[1]],
    ]
    puts "@sums_xy: " + @sums_xy.inspect if $DEBUG
  end

  def polar_canvas(r, ang)
    xy_canvas(r * Math::cos(2 * Math::PI * ang), r * Math::sin(2 * Math::PI * ang))
  end

  def xy_canvas(x, y)
    [@unit_len * x + @image_side * 0.5, @unit_len * -y + @image_side * 0.5]
  end

  def command_init
    "convert -size #{@image_side}x#{@image_side} xc:#{@bgcolor}"
  end

  def command_triangle
    if false
      command = " -fill none -stroke blue -strokewidth 2"
      command += " -draw \"circle #{xy_canvas(0,0).join(',')} #{xy_canvas(1,0).join(',')}\""
    else
      command = ""
    end

    command += " -fill none -stroke black -strokewidth 4"
    triangle_xy = @place_xy.values_at(0, 6, 9)
    command += " -draw \"polygon #{triangle_xy.flatten.join(',')}\""

    command += " -fill none -stroke black -strokewidth 2"
    lines_xy = []
    lines_xy << @place_xy.values_at(1, 2)
    lines_xy << @place_xy.values_at(3, 5)
    lines_xy << @place_xy.values_at(7, 3)
    lines_xy << @place_xy.values_at(8, 1)
    lines_xy << @place_xy.values_at(5, 8)
    lines_xy << @place_xy.values_at(2, 7)
    lines_xy.each do |line|
      command += " -draw \"line #{line.flatten.join(',')}\""
    end

    command
  end

  def command_sums
    command = " -fill none -stroke black -strokewidth 2"

    lines_xy = []
    lines_xy << [@place_xy[1], @sums_xy[0]]
    lines_xy << [@place_xy[3], @sums_xy[1]]
    lines_xy << [@place_xy[7], @sums_xy[2]]
    lines_xy << [@place_xy[8], @sums_xy[3]]
    lines_xy << [@place_xy[5], @sums_xy[4]]
    lines_xy << [@place_xy[2], @sums_xy[5]]

    lines_xy.each do |line|
      command += " -draw \"stroke-dasharray 3 3 line #{line.flatten.join(',')}\""
    end

    command += " -fill #{@bgcolor} -stroke black -strokewidth 2"
    @sums_xy.each do |x, y|
      x1 = x - @place_r * 0.7
      y1 = y - @place_r * 0.7
      x2 = x + @place_r * 0.7
      y2 = y + @place_r * 0.7
      command += " -draw \"rectangle #{x1},#{y1} #{x2},#{y2}\""
    end

    if Array === @sums
      s_a = @sums
    elsif @flag_demo
      s_a = (0..5).to_a.map {|i| i.to_s * (i % 2 == 1 ? 1 : 2)}
    else
      return command
    end
    fontname = 'Liberation-Sans-Regular'
    # fontname = ENV['FONT'] || 'Liberation-Sans-Regular'
    mag = 0.8
    pointsize = @place_r * mag
    command += " -fill black -stroke none -font #{fontname} -pointsize #{pointsize}"
    @sums_xy.each_with_index do |p0, i|
      next unless s_a[i]
      command += command_put_text(p0[0], p0[1], s_a[i].to_s, mag)
      # command += command_put_text(p0[0], p0[1], i.to_s * (i % 2 == 1 ? 1 : 2), mag)
    end

    command
  end

  def command_places
    command = " -fill #{@bgcolor} -stroke black -strokewidth 2"

    @place_xy.each do |x, y|
      command += " -draw \"circle #{x},#{y} #{x + @place_r},#{y}\""
    end

    if Array === @places
      p_a = @places
    elsif @flag_demo
      p_a = (0..9).to_a.map {|i| i.to_s * (i <= 5 ? 1 : 2)}
    else
      return command
    end
    fontname = 'Liberation-Sans-Regular'
    # fontname = ENV['FONT'] || 'Liberation-Sans-Regular'
    mag = 1.2
    pointsize = @place_r * mag
    command += " -fill black -stroke none -font #{fontname} -pointsize #{pointsize}"
    @place_xy.each_with_index do |p0, i|
      next unless p_a[i]
      command += command_put_text(p0[0], p0[1], p_a[i].to_s, mag)
      # command += command_put_text(p0[0], p0[1], i.to_s * (i <= 5 ? 1 : 2), mag)
    end

    command
  end

  def command_put_text(x, y, str, mag = 1)
    # ToDo: text position // http://www.imagemagick.org/Usage/text/#font_info
    pointsize = @place_r * mag
    case str.length
    when 1
      x -= pointsize * 0.26
    when 2
      x -= pointsize * 0.53
    end
    y += pointsize * 0.35

    " -draw \"text #{x},#{y} \'#{str}\'\""
  end

  def command_caption
    fontname = 'Liberation-Sans-Regular'
    # fontname = ENV['FONT'] || 'Liberation-Sans-Regular'
    pointsize = @place_r * 0.6

    command = " -fill black -stroke none -font #{fontname} -pointsize #{pointsize}"
    command += " -draw \"text 2,#{pointsize} \'#{@caption}\'\""

    command
  end

  def command_trim
    len1 = @sums_xy[1][0] - @place_r * 0.7
    len2 = @sums_xy[2][1] + @place_r * 0.7 + len1
    return "" if len2 >= @image_side

    command = " -crop #{len2}x#{len2}+0+0"
    command += " -resize #{@image_side}x#{@image_side}"

    command
  end

  def command_saveas
    " -quality 90 #{@filename}"
  end

  def start
    command = command_init
    command += command_triangle
    command += command_sums
    command += command_places
    command += command_caption if @caption
    command += command_trim unless @flag_keep_center
    command += command_saveas

    puts command if $DEBUG
    system command
  end
end
