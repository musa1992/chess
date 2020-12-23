# frozen_string_literal: true

require_relative 'player'
require_relative 'board_setup'
module Error
  class WrongPieceError < StandardError
    def message
      'You Picked opponents piece'
    end
  end
  class EmptySquareError < StandardError
    def message
      'You picked an empty square'
    end
  end

  class IncorrectMoveError < StandardError
    def message
      'Incorrect move for the piece'
    end
  end
  class WrongMoveError < StandardError
    def message
      'Piece can not be put on square with your piece already'
    end
  end
end

class Game
  include Error
  attr_reader :board, :players
  attr_reader :x_piece, :y_piece, :x_square, :y_square, :valid_input, :my_piece, :current_player, :new_square

  def initialize(board, players)
    @board = board
    @players = players
    @current_player = nil
    @playing_board = board.set_board
    @x_piece = nil
    @y_piece = nil
    @x_square = nil
    @y_square = nil
    @valid_input = nil
    @my_piece = nil
    @new_square = nil
  end

  def play
    x = 0
    white_king = @playing_board[7][4]
    black_king = @playing_board[0][4]
    kings = [black_king, white_king]
    captured_black = []
    captured_white = []
    loop do
      # when x = zero current player is black
      pl = x.zero? ? players.first : players.last
      player(pl)
      # when x = zero king up for checkmate is white king
      king = x.zero? ? kings.last : kings.first

      display_captured_pieces(captured_white)
      board.board.color_board(@playing_board)
      display_captured_pieces(captured_black)
      puts "#{current_player.name} make your move"
      input = gets
      @valid_input = validate_input(input)

      @x_piece = playing_piece(valid_input)[:x_pos]
      @y_piece = playing_piece(valid_input)[:y_pos]
      @x_square = chosen_square(valid_input)[:x_square]
      @y_square = chosen_square(valid_input)[:y_square]

      begin
        get_piece(x_piece, y_piece)
        move_to(x_square, y_square)

        raise Error::IncorrectMoveError unless my_piece.is_correct_move?([x_square, y_square])

        if my_piece.is_a? Pawn

          raise Error::IncorrectMoveError if my_piece.capturing_move(y_square) && new_square.is_a?(Integer)

          raise Error::IncorrectMoveError if !my_piece.capturing_move(y_square) && new_square.is_a?(GamePiece)

        end
        unless my_piece.is_a? Knight
          path = my_piece.create_path([x_piece, y_piece], [x_square, y_square])
          raise Error::IncorrectMoveError unless legal_play(@playing_board, path)
        end
        if new_square.is_a? GamePiece
          raise Error::WrongMoveError if my_piece.color == new_square.color

          # convert if else to method -- captured(color)
          if new_square.color == 'black'
            captured_black << new_square.unicode.encode('utf-8')
          else
            captured_white << new_square.unicode.encode('utf-8')
          end

        end

        my_piece.update_position([x_square, y_square])

        @playing_board = board.board.update_board([x_piece, y_piece], [x_square, y_square], @playing_board)
        if promote_pawn(@playing_board[x_square][y_square])
          puts 'Enter choice to promote your game piece'
          puts "q. Queen \nk. Knight \nr. Rook \nb. Bishop "
          letter = gets.chomp
          promoted = board.create_piece(letter, [x_square, y_square], player.color)
          @playing_board[x_square][y_square] = promoted
        end
      rescue WrongPieceError, WrongMoveError, IncorrectMoveError, EmptySquareError => e
        puts e.message
        input = gets
        @valid_input = validate_input(input)
        @x_piece = playing_piece(valid_input)[:x_pos]
        @y_piece = playing_piece(valid_input)[:y_pos]
        @x_square = chosen_square(valid_input)[:x_square]
        @y_square = chosen_square(valid_input)[:y_square]
        retry
      end

      # if my_piece.check_mate?(king.position)
      #     king_path = new_square.create_path([x_square,y_square], king.position)

      #     puts "check" if legal_play(@playing_board, king_path)
      # end

      x += 1
      x = 0 if x == 2
    end
  end

  def validate_input(user_input)
    pattern = /^[1-8]{1}[a-h]{1}\s[1-8]{1}[a-h]{1}$/
    until user_input.match?(pattern)
      puts 'Wrong Inputs Enter again in format 2a 2b '
      user_input = gets
    end
    user_input
  end

  def get_piece(x_coord, y_coord)
    piece = @playing_board[x_coord][y_coord]
    raise EmptySquareError if piece.is_a?(Integer)
    raise WrongPieceError if piece.color != current_player.color

    @my_piece = piece
  end

  def move_to(x_coord, y_coord)
    @new_square = @playing_board[x_coord][y_coord]
  end

  def player(pl)
    @current_player = pl
  end

  def playing_piece(user_input)
    x_piece = user_input[/^./].to_i - 1
    y_piece = (user_input[1].ord - 96) - 1
    { x_pos: x_piece, y_pos: y_piece }
  end

  def chosen_square(user_input)
    x_square = user_input[3].to_i - 1
    y_square = (user_input[4].ord - 96) - 1
    { x_square: x_square, y_square: y_square }
  end

  def legal_play(playing_board, path)
    pieces = []
    path.each do |arr|
      pieces << playing_board[arr.first][arr.last]
    end
    pieces.all? Integer
  end

  def display_captured_pieces(pieces)
    puts ' '
    pieces.each { |piece| print " #{piece} ".on_yellow }
    puts ' '
  end

  def promote_pawn(piece)
    x = piece.position.first
    return true if piece.is_a?(Pawn) && (x.zero? || x == 7)

    false
  end

  def instructions
    puts "Welome to chess.\nPlayer one is the black pieces.\nPlayer two represents the white pieces."
    puts 'The game is played by choosing the piece you want to move and placing it on the correct square.'
    puts "A move is made by giving input in the following format 2a 3a.\n2a represents the piece being moved.\n3a represents the square to place the piece"
  end
end

board = BoardSetUp.new

pl1 = Player.new('Moses', 'black')
pl2 = Player.new('Sheila', 'white')

players = [pl1, pl2]

g = Game.new(board, players)
g.instructions
g.play
