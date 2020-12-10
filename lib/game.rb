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

       loop do
            player = x.zero? ? players.first : players.last
            
           board.board.color_board(@playing_board)
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
                @playing_board = board.board.update_board([x_piece,y_piece],[x_square,y_square],@playing_board)
            rescue WrongPieceError => e
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
           
           
           x += 1
           x = 0 if x == 2
       end
    end
    def validate_input(user_input)
       pattern = /^[1-8]{1}[a-h]{1}\s[1-8]{1}[a-h]{1}$/
       until user_input.match?(pattern)
        puts "Wrong Inputs Enter again in format 2a 2b "
        user_input = gets
       end
       user_input
    end

    def playing_piece(user_input)
        x_piece = user_input[/^./].to_i - 1
        y_piece = (user_input[1].ord - 96) - 1
        {:x_pos => x_piece, :y_pos => y_piece}
    end

    def chosen_square(user_input)
        x_square = user_input[3].to_i - 1
        y_square = (user_input[/.$/].ord - 96) - 1 
        {:x_square => x_square, :y_square => y_piece}
    end

    def is_empty_square(playing_board,x_pos,y_pos)
        input = nil
        while playing_board[x_pos][y_pos].kind_of? Integer
            puts "You picked an empty square"
            input = gets
            input = validate_input(input)
            x_pos = playing_piece(input)[:x_pos]
            y_pos = playing_piece(input)[:y_pos]
        end
        input
    end

    def correct_piece(player, playing_board,x,y) 
        input = nil
        until player.color == playing_board[x][y].color
                puts "You picked opponents piece Enter choice again"
                input = gets
                input = validate_input(input)
                x = playing_piece(input)[:x_pos]
                y = playing_piece(input)[:y_pos]             
        end
        input
    end
    
end

board = BoardSetUp.new

pl1 = Player.new('moses', 'black')
pl2 = Player.new('sheila' , 'white')

players = [pl1, pl2]

g = Game.new(board,players)

g.play

# def retrying(a, b)
   
#     c = 0
#     begin
#       c = a + b  
        
#     rescue => exception
#         puts "enter a:"
#         a = gets.chomp.to_i
#         puts "enter b:"
#         b = gets.chomp.to_i
#         retry
#     end
#     #print "a #{a} , b #{b}\n"
#     c
# end

# puts retrying(100, '200')


# if @playing_board[x_piece][y_piece].kind_of? Integer
#     @valid_input = is_empty_square(@playing_board,x_piece,y_piece)
# end

# x = playing_piece(valid_input)[:x_pos]
# y = playing_piece(valid_input)[:y_pos]
# if player.color != @playing_board[x][y].color
#     @valid_input = correct_piece(player, @playing_board,x,y)
# end

# @x_square = chosen_square(valid_input)[:x_square]
# @y_square = chosen_square(valid_input)[:y_square]
# @x_piece = playing_piece(valid_input)[:x_pos]
# @y_piece = playing_piece(valid_input)[:y_pos]