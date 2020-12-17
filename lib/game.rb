require_relative 'player'
require_relative 'board_setup'
module Error
    class WrongPieceError < StandardError
        def message
            "You Picked opponents piece"
        end
    end
    class IncorrectMoveError < StandardError
        def message
            "Incorrect move for the piece"
        end
    end
    class WrongMoveError < StandardError
        def message
            "Piece can not be put on square with your piece already"
        end
    end

end

class Game
    include Error
    attr_reader :board, :players
    attr_reader :x_piece, :y_piece, :x_square, :y_square, :valid_input
    def initialize (board, players)
        @board = board
        @players = players
        @playing_board = board.set_board
        @x_piece = nil
        @y_piece = nil
        @x_square = nil
        @y_square = nil
        @valid_input = nil
    end

    def play
       x = 0
        white_king = @playing_board[7][4]
        black_king = @playing_board[0][4]
        kings =  [black_king, white_king]
        captured_black = []
        captured_white = []
       loop do
        
            # when x = zero current player is black 
            player = x.zero? ? players.first : players.last
            # when x = zero king up for checkmate is white king
            king = x.zero? ? kings.last : kings.first

           captured_pieces(captured_white)
           board.board.color_board(@playing_board)
           captured_pieces(captured_black)
           puts "#{player.name} make your move"
           input = gets
           @valid_input = validate_input(input)
           
           @x_piece = playing_piece(valid_input)[:x_pos]
           @y_piece = playing_piece(valid_input)[:y_pos]
           @x_square = chosen_square(valid_input)[:x_square]
           @y_square = chosen_square(valid_input)[:y_square]
           
            begin 
                raise Error::WrongPieceError if player.color != @playing_board[x_piece][y_piece].color
                raise Error::IncorrectMoveError if !@playing_board[x_piece][y_piece].is_correct_move?([x_square,y_square])
                if @playing_board[x_piece][y_piece].is_a? Pawn
                    
                    raise Error::IncorrectMoveError if @playing_board[x_piece][y_piece].capturing_move(y_square) && @playing_board[x_square][y_square].is_a?(Integer)

                    raise Error::IncorrectMoveError if !@playing_board[x_piece][y_piece].capturing_move(y_square) && @playing_board[x_square][y_square].is_a?(GamePiece)
                    
                end
                unless @playing_board[x_piece][y_piece].is_a? Knight
                    path = @playing_board[x_piece][y_piece].create_path([x_piece,y_piece],[x_square,y_square])
                    raise Error::IncorrectMoveError unless legal_play(@playing_board,path)                    
                end
                if @playing_board[x_square][y_square].kind_of? GamePiece
                    raise Error::WrongMoveError if @playing_board[x_piece][y_piece].color == @playing_board[x_square][y_square].color
                    # convert if else to method -- captured(color)
                    if @playing_board[x_square][y_square].color == 'black'
                        captured_black << @playing_board[x_square][y_square].unicode.encode('utf-8')
                    else
                        captured_white << @playing_board[x_square][y_square].unicode.encode('utf-8')
                    end
                    
                end
                
                
                @playing_board[x_piece][y_piece].update_position([x_square,y_square])
                
                @playing_board = board.board.update_board([x_piece,y_piece],[x_square,y_square],@playing_board)
                if promote_pawn(@playing_board[x_square][y_square])
                    puts "Enter choice to promote your game piece"
                    puts "q. Queen \nk. Knight \nr. Rook \nb. Bishop "
                    letter = gets.chomp
                    promoted = board.create_piece(letter,[x_square,y_square],player.color)
                    @playing_board[x_square][y_square] = promoted
                end
                
            rescue WrongPieceError => e
                puts e.message
                input = gets
                @valid_input = validate_input(input)
                @x_piece = playing_piece(valid_input)[:x_pos]
                @y_piece = playing_piece(valid_input)[:y_pos]
                @x_square = chosen_square(valid_input)[:x_square]
                @y_square = chosen_square(valid_input)[:y_square]
                retry
            rescue WrongMoveError => e
                puts e.message
                input = gets
                @valid_input = validate_input(input)
                @x_piece = playing_piece(valid_input)[:x_pos]
                @y_piece = playing_piece(valid_input)[:y_pos]
                @x_square = chosen_square(valid_input)[:x_square]
                @y_square = chosen_square(valid_input)[:y_square]
                retry           
            rescue IncorrectMoveError => e
                puts e.message
                input = gets
                @valid_input = validate_input(input)
                @x_piece = playing_piece(valid_input)[:x_pos]
                @y_piece = playing_piece(valid_input)[:y_pos]
                @x_square = chosen_square(valid_input)[:x_square]
                @y_square = chosen_square(valid_input)[:y_square]
                retry                
            rescue NoMethodError => e
                puts "You Picked an empty square"
                input = gets
                @valid_input = validate_input(input)
                @x_piece = playing_piece(valid_input)[:x_pos]
                @y_piece = playing_piece(valid_input)[:y_pos]
                @x_square = chosen_square(valid_input)[:x_square]
                @y_square = chosen_square(valid_input)[:y_square]
                retry 
            end
            
            if @playing_board[x_square][y_square].check_mate?(king.position)
                king_path = @playing_board[x_square][y_square].create_path([x_square,y_square], king.position)
                
                puts "check" if legal_play(@playing_board, king_path)
            end
            
           x += 1
           x = 0 if x == 2
       end
    end


    def validate_input(user_input)
       pattern = /^[1-8]{1}[a-h]{1}\s[1-8]{1}[a-h]{1}$/
       until user_input.match?(pattern) || user_input.match?("undo")
        puts "Wrong Inputs Enter again in format 2a 2b "
        user_input = gets
       end
       user_input
    end

    def playing_piece(user_input)
        x_piece = user_input[/^./].to_i-1 
        y_piece = (user_input[1].ord - 96)-1
        {:x_pos => x_piece, :y_pos => y_piece}
    end

    def chosen_square(user_input)
        x_square = user_input[3].to_i - 1
        y_square = (user_input[4].ord - 96) - 1
        {:x_square => x_square, :y_square => y_square}
    end

    def legal_play(playing_board, path)
        pieces = []
        path.each do |arr|
            pieces << playing_board[arr.first][arr.last]
        end
        pieces.all? Integer
    end

    def captured_pieces(pieces)
        puts " "
        pieces.each {|piece| print " #{piece} ".on_yellow}
        puts " "
    end
    
    def promote_pawn(piece)
        x = piece.position.first
        if piece.kind_of?(Pawn) && (x == 0 || x == 7)
            return true
        end
        false
    end

end

board = BoardSetUp.new

pl1 = Player.new('moses', 'black')
pl2 = Player.new('sheila' , 'white')

players = [pl1, pl2]

g = Game.new(board,players)

g.play
