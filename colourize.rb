# via: https://stackoverflow.com/questions/1489183/colorized-ruby-output-to-the-terminal
class String
  def colourize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colourize(31)
  end

  def ferrari
    colourize(31)
  end

  def green
    colourize(32)
  end

  def yellow
    colourize(33)
  end

  def blue
    colourize(34)
  end

  def pink
    colourize(35)
  end

  def light_blue
    colourize(36)
  end
end
