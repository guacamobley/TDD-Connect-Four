require "./lib/connect_four.rb"


#need to check for four in a row
#create a 7 wide x 6 tall grid
#need to check for full board
#need to check for full column
#need to add user input to a column

RSpec.describe("Connect Four") do
  describe ('#initialize') do
    it "creates an empty board" do
      board = Board.new
      expect(board.squares.all?{|row|
        row.each{ |square| square.value == ""}
      }).to eql(true)
    end
    it "creates a 7 x 6 grid" do
      board = Board.new
      expect(board.squares.all?{|row|
        row.size == 7}).to eql(true)
    end
    it "creates a 7 x 6 grid" do
      board = Board.new
      expect(board.squares.size == 6).to eql(true)
    end
  end
  describe ('#win?') do
    it "returns true if there are four of the same symbol in a row" do
      board = Board.new
      4.times do |index| board.squares[1][index].value = board.players[0].symbol end
      expect(board.win?).to eql(true)
    end
    it "returns false if there are not four of the same symbol in a row" do
      board = Board.new
      3.times do |index| board.squares[3][index].value = board.players[0].symbol end
      expect(board.win?).to eql(false)
    end
    it "returns true if there are four of the same symbol in a diagonal" do
      board = Board.new
      board.squares[1][2].value = board.players[0].symbol
      board.squares[2][3].value = board.players[0].symbol
      board.squares[3][4].value = board.players[0].symbol
      board.squares[4][5].value = board.players[0].symbol
      expect(board.win?).to eql(true)
    end
  end

  describe ('winner') do
    it "returns the symbol of the winning player if there is a winner" do
      board = Board.new
      4.times do |index| board.squares[0][index].value = board.players[0].symbol end
      expect(board.winner).to eql(board.players[0].symbol)
    end
    it "returns nil if there is no winner" do
      board = Board.new
      expect(board.winner).to eql(nil)
    end
  end

  describe ('#full?') do
    it "returns true if board is full" do
      board = Board.new
      6.times { |x|
        7.times { |y|
          board.squares[x][y].value = (x+y % 4 == 0) ? board.players[0].symbol: board.players[1].symbol
        }
      }
      expect(board.full?).to eql(true)
    end

    it "returns false if board is not full" do
      board = Board.new
      6.times { |x|
        7.times { |y|
          board.squares[x][y].value = (x+y % 30 == 0) ? "" : board.players[0].symbol
        }
      }
      expect(board.full?).to eql(false)
    end
  end

  describe ('#column_full?') do
    it "returns true if column full" do
      board = Board.new
      6.times {|x|
        board.squares[x][1].value = board.players[0].symbol
      }
      expect(board.column_full?(1)).to eql(true)
    end
    it "returns false if column not full" do
      board = Board.new
      5.times {|x|
        board.squares[x][1].value = board.players[0].symbol
      }
      expect(board.column_full?(1)).to eql(false)
    end
  end

  describe ('#Square.value') do
    it "upates contents of square if square is empty" do
      square = Square.new
      square.value = "X"
      expect(square.value).to eql("X")
    end
  end
  describe ('#Square.empty?') do
    it "returns true if square is empty" do
      square = Square.new
      expect(square.empty?).to eql(true)
    end
    it "returns false if square is not empty" do
      square = Square.new
      square.value = "X"
      expect(square.empty?).to eql(false)
    end
  end

  describe ('#Square.to_s') do
    it "returns a symbol if there is a symbol in the square" do
      square = Square.new
      square.value = "X"
      expect(square.to_s).to eql("X")
    end
    it "returns a blank space if there is no symbol in the square" do
      square = Square.new
      expect(square.to_s).to eql(" ")
    end
  end

  describe ('#change_player') do
    it 'makes players[0] the active player if player[1] is the active player' do
      board = Board.new
      board.active_player = board.players[1]
      board.change_player
      expect(board.active_player).to eql(board.players[0])
    end
    it 'makes players[1] the active player if player[0] is the active player' do
      board = Board.new
      board.active_player = board.players[0]
      board.change_player
      expect(board.active_player).to eql (board.players[1])
    end
  end

  describe('#valid_choice?') do
    it 'rejects choices that are not column numbers' do
      board = Board.new
      expect(board.valid_choice?("a")).to eql(false)
    end
    it 'rejects choices of full columns' do
      board = Board.new
      6.times do |index| board.squares[index][1] = "X" end
      expect(board.valid_choice?("1")).to eql(false)
    end
    it 'accepts valid column choices' do
      board = Board.new
      expect(board.valid_choice?("1")).to eql(true)
    end

  end


  describe('#add_to_column') do
    it "adds the active player's symbol to the top of the specified column" do
      board = Board.new
      board.active_player = board.players[0]
      4.times {|y|
        board.squares[y][2] = board.active_player.symbol
      }
      board.change_player
      board.add_to_column(2)
      expect(board.squares[4][2].value).to eql(board.active_player.symbol)
    end

    it "adds the active player's symbol to the top of the specified column" do
      board = Board.new
      board.active_player = board.players[1]
      board.add_to_column(2)
      expect(board.squares[0][2].value).to eql(board.active_player.symbol)
    end
  end


end
