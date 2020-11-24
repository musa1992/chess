# frozen_string_literal: true

require 'colorize'
class GamePiece
  attr_reader :color, :unicode, :position

  def initialize(color, unicode, position)
    @color = color
    @unicode = unicode
    @position = position
  end

  def move(pos)
    update_position(pos) if all_possible_moves.any?(pos)
  end

  def update_position(pos)
    @position = pos
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
  def all_possible_moves_helper(x_arr, y_arr, n)
    moves = []
    n.times do |i|
      moves << [position[0] + x_arr[i], position[1] + y_arr[i]]
    end
    correct_moves(moves)
  end
  def correct_moves(moves)
    moves.delete_if { |del| del.any? { |i| i.negative? || i > 7 } }
    moves   
  end
end
class King < GamePiece
  def all_possible_moves
    x = [1, -1, 0, 0]
    y = [0, 0, 1, -1]
    moves = []
    4.times do |i|
      moves << [position[0] + x[i], position[1] + y[i]]
    end
    correct_moves(moves)
  end
end

class Queen < GamePiece
  def all_possible_moves
    x = [1, -1, 0, 0, -1, 1, -1, 1]
    y = [0, 0, 1, -1, 1, 1, -1, -1]
    n = 8
    moves = []
    7.times do
      moves << all_possible_moves_helper(x, y, n)
      x = generate_coords(x)
      y = generate_coords(y)
    end
    moves.delete_if { |elem| elem.flatten.empty? }
    moves.flatten(1)
  end

  
end

class Rook < GamePiece
  def all_possible_moves
    x = [1, -1, 0, 0]
    y = [0, 0, 1, -1]
    n = 4
    moves = []
    7.times do
      moves << all_possible_moves_helper(x, y, n)
      x = generate_coords(x)
      y = generate_coords(y)
    end
    moves.delete_if { |elem| elem.flatten.empty? }
    moves.flatten(1)
  end

end
class Bishop < GamePiece
  def all_possible_moves
    x = [-1, 1, -1, 1]
    y = [1, 1, -1, -1]
    n = 4
    moves = []
    7.times do
      moves << all_possible_moves_helper(x, y, n)
      x = generate_coords(x)
      y = generate_coords(y)
    end
    moves.delete_if { |elem| elem.flatten.empty? }
    moves.flatten(1)
  end

end

class Knight < GamePiece
  def all_possible_moves
    x = [2, 2, -2, -2, 1, 1, -1, -1]
    y = [1, -1, 1, -1, 2, -2, 2, -2]
    moves = []
    8.times do |i|
      moves << [position[0] + x[i], position[1] + y[i]]
    end
    moves.delete_if { |del| del.any? { |i| i.negative? || i > 7 } }
    moves
  end
end

class Pawn < GamePiece
  attr_reader :shift
  def initialize(color, unicode, position)
    super
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
    x = [shift, f, shift, shift]
    y = [0, 0, 1, -1]
    moves = []
    4.times do |i|
      moves << [position[0] + x[i], position[1] + y[i]]
    end
    correct_moves(moves)
  end

  def all_possible_moves
    x = [shift, shift, shift]
    y = [0, 1, -1]
    moves = []
    3.times do |i|
      moves << [position[0] + x[i], position[1] + y[i]]
    end
    return first_move if @original_pos == position

    correct_moves(moves)
  end
end

q = Queen.new('mo', 'mo', [4,3])

print q.all_possible_moves

puts " "

q.move([5,3])

print q.all_possible_moves

puts " "
q.move([0,3])

print q.all_possible_moves

puts " "
puts " King"
q = King.new('mo', 'mo', [0,5])

print q.all_possible_moves
puts " "

q.move([1,5])

print q.all_possible_moves

puts " "
q.move([2,5])

print q.all_possible_moves

puts " "