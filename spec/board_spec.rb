require './lib/board'

describe Board do
    before(:each) do
        @board = Board.new
    end
    context 'test that the board gets updated when piece is moved' do
        describe "#update_board" do
            it 'should return a board with the piece moved to correct square' do
                x = @board.board[0][0]
                expect(@board.update_board([0,0],[2,3])[2][3]== x).to be true
            end
            it 'should return a board with the piece moved to correct square' do
                x = @board.board[7][7]
                expect(@board.update_board([7,7],[0,0])[0][0] == x).to be true
            end
            it 'should return a board with the former position empty after a succesful move' do
                expect(@board.update_board([7,7],[0,0])[7][7].is_a?Integer).to be false
            end
            it 'should return a board with the former position empty after a succesful move' do
                expect(@board.update_board([0,0],[2,3])[0][0].is_a?Integer).to be false
            end
        end
    end

end