# frozen_string_literal: true

require 'colorize'
class King
  attr_reader :color, :unicode, :position

  def initialize(color, unicode, position)
    @color = color
    @unicode = unicode
    @position = position
  end

  def all_possible_moves
    x = [1, -1, 0, 0]
    y = [0, 0, 1, -1]
    moves = []
    4.times do |i|
      moves << [position[0] + x[i], position[1] + y[i]]
    end
    moves.delete_if { |del| del.any? { |i| i.negative? || i > 7 } }
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
    x = [1, -1, 0, 0, -1, 1, -1, 1]
    y = [0, 0, 1, -1, 1, 1, -1, -1]
    moves = []
    7.times do
      moves << all_possible_moves_helper(x, y)
      x = generate_coords(x)
      y = generate_coords(y)
    end
    moves.delete_if { |elem| elem.flatten.empty? }
    moves.flatten(1)
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

  def all_possible_moves_helper(x_arr, y_arr)
    moves = []
    8.times do |i|
      moves << [position[0] + x_arr[i], position[1] + y_arr[i]]
    end
    moves.delete_if { |del| del.any? { |i| i.negative? || i > 7 } }
    moves
  end

  def move(pos)
    update_position(pos) if all_possible_moves.any?(pos)
  end

  def update_position(pos)
    @position = pos
  end
end

class Rook
    attr_reader :color, :unicode, :position

    def initialize(color, unicode, position)
      @color = color
      @unicode = unicode
      @position = position
    end
  
    def all_possible_moves
      x = [1, -1, 0, 0]
      y = [0, 0, 1, -1]
      moves = []
      7.times do
        moves << all_possible_moves_helper(x, y)
        x = generate_coords(x)
        y = generate_coords(y)
      end
      moves.delete_if { |elem| elem.flatten.empty? }
      moves.flatten(1)
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
  
    def all_possible_moves_helper(x_arr, y_arr)
      moves = []
      4.times do |i|
        moves << [position[0] + x_arr[i], position[1] + y_arr[i]]
      end
      moves.delete_if { |del| del.any? { |i| i.negative? || i > 7 } }
      moves
    end
  
    def move(pos)
      update_position(pos) if all_possible_moves.any?(pos)
    end
  
    def update_position(pos)
      @position = pos
    end
end
class Bishop
    attr_reader :color, :unicode, :position

    def initialize(color, unicode, position)
      @color = color
      @unicode = unicode
      @position = position
    end
  
    def all_possible_moves
      x = [-1, 1, -1, 1]
      y = [1, 1, -1, -1]
      moves = []
      7.times do
        moves << all_possible_moves_helper(x, y)
        x = generate_coords(x)
        y = generate_coords(y)
      end
      moves.delete_if { |elem| elem.flatten.empty? }
      moves.flatten(1)
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
  
    def all_possible_moves_helper(x_arr, y_arr)
      moves = []
      4.times do |i|
        moves << [position[0] + x_arr[i], position[1] + y_arr[i]]
      end
      moves.delete_if { |del| del.any? { |i| i.negative? || i > 7 } }
      moves
    end
  
    def move(pos)
      update_position(pos) if all_possible_moves.any?(pos)
    end
  
    def update_position(pos)
      @position = pos
    end
end

class Knight
    attr_reader :color, :unicode, :position

    def initialize(color, unicode, position)
      @color = color
      @unicode = unicode
      @position = position
    end
  
    def all_possible_moves
      x = [2,2,-2,-2,1,1,-1,-1]
      y = [1,-1,1,-1,2,-2,2,-2]
      moves = []
      8.times do |i|
        moves << [position[0] + x[i], position[1] + y[i]]
      end
      moves.delete_if { |del| del.any? { |i| i.negative? || i > 7 } }
      moves
    end
  
    def move(pos)
      update_position(pos) if all_possible_moves.any?(pos)
    end
  
    def update_position(pos)
      @position = pos
    end   
end

class Pawn
    attr_reader :color, :unicode, :position, :shift

    def initialize(color, unicode, position)
      @color = color
      @unicode = unicode
      @position = position
      @original_pos = position
      @shift = shift_factor
    end

    def shift_factor
        if @original_pos.first == 6
             -1
        else
            1
        end
    end

    def first_move
        f = shift * 2
        x = [shift, f,shift, shift]
        y = [0, 0,1, -1] 
        moves = []
        4.times do |i|
            moves << [position[0] + x[i], position[1] + y[i]]
          end
          moves.delete_if { |del| del.any? { |i| i.negative? || i > 7 } }
          moves
    end
  
    def all_possible_moves
      x = [shift, shift, shift]
      y = [0, 1, -1]
      moves = []
      3.times do |i|
        moves << [position[0] + x[i], position[1] + y[i]]
      end
      moves.delete_if { |del| del.any? { |i| i.negative? || i > 7 } }
      return first_move if @original_pos == position
      moves
    end
  
    def move(pos)
      update_position(pos) if all_possible_moves.any?(pos)
    end
  
    def update_position(pos)
      @position = pos
    end

end

b = Pawn.new('mo','mo', [1,3])

print b.all_possible_moves
b.move([3,1])
puts ' '

print b.all_possible_moves

puts ' '



