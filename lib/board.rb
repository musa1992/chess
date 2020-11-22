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
          if index.even?
            if !el.is_a? Integer
              print " #{el} ".on_magenta
            else
              print '   '.on_magenta
            end
          else
            if !el.is_a? Integer
              print " #{el} ".on_yellow
            else
              print '   '.on_yellow
            end
          end
        else
          if index.even?
            if !el.is_a? Integer
              print " #{el} ".on_yellow
            else
              print '   '.on_yellow
            end
          else
            if !el.is_a? Integer
              print " #{el} ".on_magenta
            else
              print '   '.on_magenta
            end
          end
        end
      end
      puts ' '
    end
    puts '   a  b  c  d  e  f  g  h'
  end
end

br = Board.new

br.board[0][0] = 'm'

br.color_board(br.board)
