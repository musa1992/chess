require_relative 'player'
require_relative 'board_setup'
class Game
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

           if @playing_board[x_piece][y_piece].kind_of? Integer
                @valid_input = is_empty_square(@playing_board,x_piece,y_piece)
           end

           @x_piece = playing_piece(valid_input)[:x_pos]
           @y_piece = playing_piece(valid_input)[:y_pos]
           if player.color != @playing_board[x_piece][y_piece].color
                @valid_input = correct_piece(player, @playing_board)
           end
           
           @x_square = chosen_square(valid_input)[:x_square]
           @y_square = chosen_square(valid_input)[:y_square]
           @x_piece = playing_piece(valid_input)[:x_pos]
           @y_piece = playing_piece(valid_input)[:y_pos]

           @playing_board = board.board.update_board([x_piece,y_piece],[x_square,y_square],@playing_board)
           
           x += 1
           break if x == 6
       end
    end
    def validate_input(user_input)
       pattern = /^[1-7]{1}[a-h]{1}\s[1-7]{1}[a-h]{1}$/
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

    def correct_piece(player, playing_board)
        input = nil
        until player.color == playing_board[x_piece][y_piece].color
            
            if playing_board[x_piece][y_piece].kind_of? Integer
                input = is_empty_square(@playing_board,x_piece,y_piece)
                input = validate_input(input)
                x_piece = playing_piece(input)[:x_pos]
                y_piece = playing_piece(input)[:y_pos]
            else
                puts "You picked opponents piece Enter choice again"
                input = gets
                input = validate_input(input)
                x_piece = playing_piece(input)[:x_pos]
                y_piece = playing_piece(input)[:y_pos] 
            end            
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
