require 'colorize'
class King
    attr_reader :color, :unicode, :position

    def initialize(color, unicode, position)
        @color = color
        @unicode = unicode
        @position = position
    end
    
    def all_possible_moves
        x = [1,-1,0,0]
        y = [0,0,1,-1]
        moves = []
        4.times do |i|
            moves << [position[0] + x[i], position[1] + y[i]]
        end
        moves.delete_if {|del| del.any?{|i| i < 0 || i > 7}}
        moves
    end

    def move(pos)
       update_position(pos) if all_possible_moves.any?(pos)
    end

    def update_position(pos)
        @position = pos
    end

end

class Queen
    attr_reader :color, :unicode, :position

    def initialize(color, unicode, position)
        @color = color
        @unicode = unicode
        @position = position
    end

    def all_possible_moves
        x = [1,-1,0,0,-1,1,-1,1]
        y = [0,0,1,-1,1,1,-1,-1]
        moves = []
        7.times do 
            moves << all_possible_moves_helper(x,y)
            x = generate_coords(x)
            y = generate_coords(y) 
        end
        moves.delete_if {|elem| elem.flatten.empty?}
        moves
    end
    def generate_coords(arr)
        arr.map do |el|
            if el.positive?
                el + 1
            elsif el.negative?
                el + -1
            else
                el
            end
        end
    end

    def all_possible_moves_helper(x,y)
        moves = []
        8.times do |i|
            moves << [position[0] + x[i], position[1] + y[i]]
        end
        moves.delete_if {|del| del.any?{|i| i < 0 || i > 7}}
        moves        
    end
end

q = Queen.new(" mo", "mo", [0,7])

print q.all_possible_moves

puts " "



