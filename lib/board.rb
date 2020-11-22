# frozen_string_literal: true

require 'colorize'
# makes the game board
class Board
  attr_accessor :board
  def initialize
    @board = make_board
  end

  def make_board
    board = []
    8.times do
      row = []
      8.times do |x|
        row << x + 1
      end
      board << row
    end
    board
  end

  def color_board(board)
    board.each_with_index do |row, idx|
      print "#{idx + 1} "
      row.each_with_index do |el, index|
        if idx.even?
          index.even? ? light_color(el) : dark_color(el)
        end
        if idx.odd?
          index.even? ? dark_color(el) : light_color(el)
        end
      end
      puts ' '
    end
    puts '   a  b  c  d  e  f  g  h'
  end

  def light_color(element)
    element.is_a?(Integer) ? (print '   '.on_magenta) : (print " #{element} ".on_magenta)
  end

  def dark_color(element)
    element.is_a?(Integer) ? (print '   '.on_yellow) : (print " #{element} ".on_yellow)
  end
end

br = Board.new

br.board[0][0] = 'm'

br.color_board(br.board)
