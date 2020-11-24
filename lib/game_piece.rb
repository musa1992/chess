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

k = King.new('black', 'bk', [0,4])
z = King.new('black', 'bl', [5,4])
a = King.new('black', 'bz', [1,4])


my_pieces = [k,z,a]

my_pieces.each do |piece|
    print "#{piece.all_possible_moves} + #{piece.unicode}"
    puts " "
end

puts " "



