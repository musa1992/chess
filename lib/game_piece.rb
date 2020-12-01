# frozen_string_literal: true

class GamePiece
  attr_reader :color, :unicode, :position

  def initialize(color, unicode, position)
    @color = color
    @unicode = unicode
    @position = position
  end

  def is_correct_move?(pos)
    if all_possible_moves.any?(pos)
      update_position(pos) 
      return true
    end
    false
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

  def format_array(moves)
    moves.delete_if { |elem| elem.flatten.empty? }
    moves.flatten(1)
  end
  
  def create_path(current_pos, new_pos)
    
    case current_pos.first
    
    when (current_pos[0] < new_pos[0]) # up
      
      x = -1
      y = 0
      generate_path(x, y, current_pos,new_pos)
    when current_pos.first > new_pos.first # down
      
      x = 1
      y = 0
      generate_path(x, y, current_pos,new_pos)
    when current_pos.last < new_pos.last # right
      
      x = 0
      y = 1
      generate_path(x, y, current_pos,new_pos)
    when current_pos.last > new_pos.last # left
      
      x = 0
      y = -1
      generate_path(x, y, current_pos,new_pos)
    when current_pos.first > new_pos.first && current_pos.last < new_pos.last # up-right
      
      x = -1
      y = 1
      generate_path(x, y, current_pos,new_pos)
    when current_pos.first > new_pos.first && current_pos.last > new_pos.last # up - left
      
      x = -1
      y = -1
      generate_path(x, y, current_pos,new_pos)
    when current_pos.first < new_pos.first && current_pos.last < new_pos.last # down_right
      x = 1
      y = 1
      generate_path(x, y, current_pos,new_pos)
    when current_pos.first < new_pos.first && current_pos.last > new_pos.last # down_left
      x = 1
      y = -1
      generate_path(x, y, current_pos,new_pos)
    else
      x = 1
      y = 0
      generate_path(x, y, current_pos,new_pos)
    end
  end

  def generate_path(x, y, current_pos, new_pos)
    path = []
    pos = []
      until current_pos.first == new_pos.first && current_pos.last == new_pos.last
        current_pos[0] = current_pos.first + x
        current_pos[1] = current_pos.last +  y
        pos = [current_pos.first, current_pos.last]
        path << pos
      end
      path
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
    format_array(moves)
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
    format_array(moves)
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
    format_array(moves)
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
    format_array(moves)
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

r = Queen.new("m", 'r' ,[0,0])

print r.create_path([0,0], [6,0])

puts " "