require_relative 'game_piece'
require_relative 'board'

module Setup
    def pieces(row,color)
        arr_1 = ['r','n','b','q','k','b','n','r']
        arr_2 = ['p','p','p','p','p','p','p','p']
        arr = []
        if row == 7 || row == 0
            arr = arr_1
        else
            arr = arr_2
        end
        my_pieces = []
        y = 0
        arr.each do |e|
            pos = [row]
            pos << y
            my_pieces << create_piece(e,pos,color)
            y += 1
        end
        my_pieces
    end

    def create_piece(letter,pos,color)
        case letter
        when 'r'
            if color.eql? 'black' 
                unicode = "\u265C"
            else
                unicode = "\u2656"
            end
            Rook.new(color,unicode,pos)
        when 'n'
            if color.eql? 'black'
                unicode = "\u265E"
            else
                unicode = "\u2658"
            end
            Knight.new(color,unicode,pos)
        when 'b'
            if color.eql? 'black'
               unicode = "\u265D"
            else
               unicode = "\u2657"
            end
            Bishop.new(color,unicode,pos)
        when 'q'
            if color.eql? 'black'
                unicode = "\u265B"
            else
                unicode = "\u2655"
            end
            Queen.new(color,unicode,pos)
        when 'k'
            if color.eql? 'black' 
                unicode = "\u265A"
            else
                unicode = "\u2654"
            end
            King.new(color,unicode,pos)
        when 'p'

            if color.eql? 'black' 
               unicode = "\u265F"
            else
                unicode = "\u2659"
            end
            Pawn.new(color,unicode,pos)
        else
            'unkown object'
        end
    end
end


class BoardSetUp
    include Setup

    
end



br = BoardSetUp.new


print br.pieces(7,'white')

puts ' '
