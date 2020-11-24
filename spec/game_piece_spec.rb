require './lib/game_piece'

describe King do
    before (:each) do
        @king = King.new('black',"\u265A", [0,4])
    end
    context 'test that position will get updated correctly' do 
        describe "#update_position" do
            it 'should return an array of 2 elements showing new position' do
                expect(@king.update_position())
            end
        end
    end
end