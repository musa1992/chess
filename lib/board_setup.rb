# frozen_string_literal: true

require_relative 'game_piece'
require_relative 'board'

module Setup
  def board
    board = Board.new
  end

  def pieces(row, color)
    arr_1 = %w[r n b q k b n r]
    arr_2 = %w[p p p p p p p p]
    arr = []
    arr = if row == 7 || row.zero?
            arr_1
          else
            arr_2
          end
    my_pieces = []
    y = 0
    arr.each do |e|
      pos = [row]
      pos << y
      my_pieces << create_piece(e, pos, color)
      y += 1
    end
    my_pieces
  end

  def create_piece(letter, pos, color)
    case letter
    when 'r'
      unicode = if color.eql? 'black'
                  "\u265C"
                else
                  "\u2656"
                end
      Rook.new(color, unicode, pos)
    when 'n'
      unicode = if color.eql? 'black'
                  "\u265E"
                else
                  "\u2658"
                end
      Knight.new(color, unicode, pos)
    when 'b'
      unicode = if color.eql? 'black'
                  "\u265D"
                else
                  "\u2657"
                end
      Bishop.new(color, unicode, pos)
    when 'q'
      unicode = if color.eql? 'black'
                  "\u265B"
                else
                  "\u2655"
                end
      Queen.new(color, unicode, pos)
    when 'k'
      unicode = if color.eql? 'black'
                  "\u265A"
                else
                  "\u2654"
                end
      King.new(color, unicode, pos)
    when 'p'

      unicode = if color.eql? 'black'
                  "\u265F"
                else
                  "\u2659"
                end
      Pawn.new(color, unicode, pos)
    else
      'unkown object'
    end
  end

  def white_pawns
    pieces(6, 'white')
  end

  def white_major
    pieces(7, 'white')
  end

  def black_pawns
    pieces(1, 'black')
  end

  def black_major
    pieces(0, 'black')
  end
end

class BoardSetUp
  include Setup
  attr_accessor :full_board
  def initialize
    @full_board = set_board
  end

  def set_board
    @board = board
    playing_board = @board.board
    my_pieces = [black_major, black_pawns, white_pawns, white_major]
    rows = [0, 1, 6, 7]

    4.times do |i|
      insert_piece(playing_board, my_pieces[i], rows[i])
    end
    playing_board
  end

  def insert_piece(board, array, row)
    8.times do |i|
      board[row][i] = array[i]
    end
  end
end
