#need to construct a 7 wide by 6 tall array
#players alternate dropping tokens into it.
#need to check for win after each turn
#
#winning occurs if there are 4 tokens in a row, column, or diagonal
#that's a lot of rows, columns, and diagonals to check
#tie occurs if board fills up without a win
#
#
#
#Need a board that knows what size it is, and knows what the possible winning rows/columns are
#
#need ability to play a token in a given column.  Give error if you try to play in a full column.





class Square
  attr_accessor :value

  def initialize
    @value = ""
  end

  def empty?
    return value == ""
  end

  def to_s
    value == "" ? " " : value
  end
end

class Player
  #each player has a symbol. The board will have two players
  #handles user input?
  attr_accessor :symbol
  def initialize symbol
    @symbol = symbol
  end

  def prompt_user_for_choice
    #puts the prompt for the player
  end

  def get_user_choice
    #user enters a choice.  Validate it to make sure
  end


end

class Board

  attr_accessor :squares, :players, :active_player

  def play_game
    until (win? || full?)
      display_board

      add_to_column(prompt_user_for_choice)

      change_player
    end

    display_board

    if win?
      display_winner
    else
      display_full_message
    end
  end


  def display_board
    puts "---------------"
    5.downto(0) {|row|
      display_row row
      puts "---------------"
    }
    puts " 0 1 2 3 4 5 6 "
  end

  def display_winner
    puts "congrats, #{winner}!.  You're the winner!"
  end

  def display_full_message
    puts "Oh no! It's a tie!"
  end

  def prompt_user_for_choice
    puts "Please choose a column to which to add the #{active_player.symbol} symbol:"
    column = gets.chomp
    until valid_choice?(column)
      puts "Please choose a column (0-6) that is not already full"
      column = gets.chomp
    end
    return column.to_i
  end

  def valid_choice? column
    return false unless ("0".."6").include? column
    return !column_full?(column.to_i)
  end


  def initialize
    @players = []
    @players.push(Player.new("X"))
    @players.push(Player.new("O"))
    @active_player = players[0]
    @squares = Array.new(6) {Array.new(7) {Square.new}}

    #set up an empty board with the given symbols for each player
  end

  def win?
    #check for winner
    check_for_winner ? true : false
  end

  def winner
    #return the winner if there is one, nil otherwise.
    win? ? check_for_winner : nil
  end

  def full?
    squares.all?{|row|
      row.none?{|square| square.empty?
      }
    }
  end

  def column_full? column
    columnToCheck = get_column column

    columnToCheck.none? {|square| square.empty?}
  end

  def add_to_column column
    return false if column_full? column
    columnToPush = get_column column
    6.times{|row|
      square = columnToPush[row]
      if square.empty?
        square.value = active_player.symbol
        return true
      end
    }
    return false
  end

  def change_player
    @active_player = @active_player == players[0] ? players[1] : players[0]
  end

    #add specified symbol to top of column #column_full? has already checked that the column is not full.

  private

  def display_row row
    output = "|"
    7.times do |column| output += squares[row][column].to_s + "|" end
    puts output
  end

  def lines_to_check
    #build an array of rows, columns, and diagonals to check
    get_rows + get_columns + get_diagonals
  end

  def get_columns
    rows = []
    7.times{|y|
      3.times{|x|
        rows << [squares[x][y],squares[x+1][y],squares[x+2][y],squares[x+3][y]]
      }
    }
    rows
  end

  def get_column column
    columnToGet = []
    6.times{|row|
      columnToGet << squares[row][column]
    }
    columnToGet
  end

  def get_rows
    columns = []
    6.times{|x|
      4.times{|y|
        columns << [squares[x][y], squares[x][y+1], squares[x][y+2], squares[x][y+3]]
      }
    }
    columns
  end

  def get_diagonals
    diagonals = []
    3.times{|x|
      4.times{|y|
        diagonals << [squares[x][y],squares[x+1][y+1], squares[x+2][y+2], squares[x+3][y+3]]
        diagonals << [squares[x+3][y], squares[x+2][y+1], squares[x+1][y+2], squares[x+3][y]]
      }
    }
    diagonals
  end



  def check_for_winner
    lines_to_check.each{|line|
      symbol = check_line line
      return symbol unless symbol.nil?
    }
    return nil
  end

  def check_line line
    players.each{ |player|
      return player.symbol if line.all? {|square| square.value == player.symbol}
    }
    return nil
  end
end

#uncomment next two lines to play the game
board = Board.new
board.play_game


