class Player

  attr_accessor :name, :symb     #allow the class var name and symb to be read and modified without needing a method

  def initialize(player_id, symb)   #called on Player.new
  	compteur = 0
  	puts "Nombre de parties: #{compteur}"
    puts "Bienvenue à vous!\n#{player_id}, Entre ton prénom : "  #ask the player in creation to set its nickname
    @name = gets.chomp                        #user nick
    @symb = symb          #x or o depending on arg
  end
end

class Case  #case object
  
  attr_accessor :status  #access the status of the case called

  def initialize(val)

    @status = val   #defaultly set on " " via board class

  end

end


class Board   #set and print the board

  def initialize   #generate all the cases in global variables


    $c1 = Case.new(" ")
    $c2 = Case.new(" ")
    $c3 = Case.new(" ")
    $c4 = Case.new(" ")
    $c5 = Case.new(" ")
    $c6 = Case.new(" ")
    $c7 = Case.new(" ")
    $c8 = Case.new(" ")
    $c9 = Case.new(" ")

  end

  def display_board  #print the grid via a string .... a bit dirty but functional

     # \n means go to newline ... and a \ is needed before every special character (such as \-|/....)

     tab = " #{$c1.status} \| #{$c2.status} \| #{$c3.status} \n\-\-\-\|\-\-\-\|\-\-\- \n #{$c4.status} \| #{$c5.status} \| #{$c6.status} \n\-\-\-\|\-\-\-\|\-\-\- \n #{$c7.status} \| #{$c8.status} \| #{$c9.status} "

    puts tab #prints the tab 

  end

  def display_tuto

    tab = " 1 \| 2 \| 3 \n\-\-\-\|\-\-\-\|\-\-\- \n 4 \| 5 \| 6 \n\-\-\-\|\-\-\-\|\-\-\- \n 7 \| 8 \| 9 "


    puts "\nComment jouer:\nChoisis une case en tapant sa lettre:"
    puts tab #prints the tutorial tab
    puts "----------------------------\n"
    sleep(2) #sleeps 2sec so you can read the quick tutorial

  end

end


class Game

  def initialize    #launches when Game.new is called
    @turn = 0    #turn counter
    @choice_left = ["1","2","3","4","5","6","7","8","9"] # list the none used cases in case a player pick a used one
  end

  def game_start  #where it begins

    puts "Initialisation ..."
    @players = []
    @players[0] = Player.new("Joueur 1 (Tu sera le rose)", "♡") # create player 1 on the players tab[0]
    @players[1] = Player.new("Joueur 2 (Tu sera le bleu)", "❤") #create player 2 on the players tab [1]

    puts"\n---------------------------"
    puts "\nBienvenue au Tic Tac Toe! !"
    puts "Joueur 1: #{@players[0].name} ------ Joueur 2: #{@players[1].name}" 

    @board = Board.new  #generate the board
    @board.display_tuto #display it

    
    while true #infinite loop

      play_turn #method in wich the player make it's choice

      if win_combination_check == true   #checks in the methode is someone has won yet
        puts "\nEt #{@players[@turn%2].name} gagne!" #display victory message :D
        puts "Voulez vous rejouer? (y/n)"
        answer = gets.chomp
        	if answer == "y"
        		game = Game.new #create a new game 
				game.game_start #calls the start method that launch the game
			else break
        	end

      elsif @turn == 8  #if the turn counter reach 8 there is no possibility left 
        puts "\nC'est une égalité!"
        puts "Voulez vous rejouer? (y/n)"
        answer = gets.chomp
        	if answer == "y"
        		game = Game.new #create a new game
				game.game_start #calls the start method that launch the game
			else break
        	end

      end
      @turn += 1 #iterate turn counter
    end

  end

  def play_turn #player's action's method

    @current_player = @players[@turn%2].name  #ok so this means : if the turn is pair its player 1 else its player 2  and take its name
    puts "\n C'est au tour de #{@current_player}, choisis une case:"
    @player_choice = ""

    while true
      @player_choice = gets.chomp #player gives a number between 1..9

      unless @choice_left.include?(@player_choice) #if the player numb is not on the list of available cases it puts a message and displays the available cases
        puts "\nChoisis une case qui est libre! \n Il te reste : #{@choice_left}"
      else
        @choice_left.delete(@player_choice) #remove the number user inputed from the list of available cases
        break #ends the loop
      end
    end

      case @player_choice #depending on what the user inputed and passed the checking it will modify the corresponding case
      when "1"
        $c1.status = @players[@turn%2].symb
      when "2"
        $c2.status = @players[@turn%2].symb
      when "3"
        $c3.status = @players[@turn%2].symb
      when "4"
        $c4.status = @players[@turn%2].symb
      when "5"
        $c5.status = @players[@turn%2].symb
      when "6"
        $c6.status = @players[@turn%2].symb
      when "7"
        $c7.status = @players[@turn%2].symb
      when "8"
        $c8.status = @players[@turn%2].symb
      when "9"
        $c9.status = @players[@turn%2].symb
      end

      @board.display_board #displays the board updated  then go back to the game loop
      

    end


  def win_combination_check #checks if  there is a winner

    #puts all the cases values in a tab
    @tab = [[$c1.status,$c2.status,$c3.status],[$c4.status,$c5.status,$c6.status],[$c7.status,$c8.status,$c9.status]]


    #check all the lines and else all the column
    (0..2).each do |i|
      if @tab[i][0] == @tab[i][1] && @tab[i][1] == @tab[i][2]
        return true unless @tab[i][0] == " " #return true unless one of the  first value of any line is = to blank

    elsif @tab[0][i] ==@tab[1][i] && @tab[1][i] == @tab[2][i]
        return true unless @tab[0][i] == " "#same here for column
    end
end

if ( @tab[0][0] == @tab[1][1] && @tab[1][1] == @tab[2][2] ) ||
  ( @tab[0][2] == @tab[1][1] && @tab[1][1] == @tab[2][0] )
      return true unless @tab[1][1] == " " #returns true unless the 5th case (middle) is == to blank
  else
      return false #no winning combination found so return false
    end
    

end

end

game = Game.new #create a new game
game.game_start #calls the start method that launch the game