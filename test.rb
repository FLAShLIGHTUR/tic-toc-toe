class Player
    attr_reader :type
  
    def initialize(type)
      @type = type
    end
  end
  
  class Cell
    attr_reader :pos, :type
  
    def initialize(type, pos)
      @type = type
      @pos = pos
    end
  end
  
  class GameBoard
    WIN_SITUATIONS = [[0,1,2], [3,4,5], [6,7,8], 
                      [0,3,6], [1,4,7], [2,5,8], 
                      [0,4,8], [2,4,6]]          
  
    def initialize
      @cells = [0, 0, 0,
                 0, 0, 0,
                 0, 0, 0]
      @players = []
  
      (1..2).each { |i| add_player(i) }
  
      @win = 0
    end
  
    def add_player(player)
      if player == 1
        system('clear') or system('cls')
        puts "Player 1, which piece do you want? (X/O)" 
  
        cell_set = false
        while !cell_set
          cell = gets.chomp.upcase
          unless cell == "X" || cell == "O"
            puts "Please enter X or O!"
          else
            cell_set = true
          end
        end
  
        @players[1] = Player.new(cell == "X" ? 1 : 2)
      elsif player == 2
        @players[2] = Player.new(@players[1].type == 1 ? 2 : 1)
      end
    end
  
    def add_cell(p)
      @cells[p.pos] = p
    end
  
    def player_move(player)
      puts "Player #{player}, select where to place your #{@players[player].type == 1 ? "X" : "O"} (1..9)"
      render_board(false)
  
      pos_set = false
      while !pos_set
        pos = gets.chomp.to_i
  
        if !(1..9).include?(pos)
          puts "Please enter a number 1 through 9!"
        elsif @cells[pos-1] != 0
          puts "There's already a piece there! Try another position."
        else
          pos -= 1 # go from human to array position
          pos_set = true
        end
      end
      
      add_cell(Cell.new(@players[player].type, pos))
    end
  
    def render_board(render_cell = true)
      if render_cell
        display_board = 
          @cells.collect do |p|
            begin
              type = p.type
            rescue
              " "
            else
              case type
              when 1
                "X"
              when 2
                "O"
              end
            end
          end
      else
        display_board = [*(1..9)]
      end
  
      puts " #{display_board[0]} | #{display_board[1]} | #{display_board[2]} "
      puts "___________"
      puts " #{display_board[3]} | #{display_board[4]} | #{display_board[5]} "
      puts "___________"
      puts " #{display_board[6]} | #{display_board[7]} | #{display_board[8]} "
    end 
  
    def game_won?
      WIN_SITUATIONS.each do |situation|
        result = 
          situation.collect do |pos|
            begin
              @cells[pos].type
            rescue
              @cells[pos]
            end
          end
  
        first_pos = result[0]
        won = result.all? {|pos| pos != 0 && pos == first_pos}
        if won 
          @win = first_pos == @players[1].type ? 1 : 2
          break
        end
      end
      return @win
    end
  
    def game_loop
      (1..9).each do |i|
        system('clear') or system('cls')
        puts "Current board:"
        render_board
  
        player_move(i.odd? ? 1 : 2)
        
        won = game_won?
        return won unless won == 0
      end
      return 0
    end
  end
  
  game_board = GameBoard.new
  
  result = game_board.game_loop
  if result == 0
    system('clear') or system('cls')
    puts "Current board:"
    game_board.render_board
    puts "Cat's game!"
  else
    system('clear')
    puts "Current board:"
    game_board.render_board
    puts "Player #{result} wins!"
  end