require 'colorize'

class Player

  attr_accessor :name, :symb     #permet aux classes de variable name et symb d'être lues et modifiées sans avoir besoin de méthode
    $counter = 0
    def initialize(player_id, symb)   #appeler par Player.new
        puts "Nombre de parties: #{$counter}\n"
        puts ""
        puts "Bienvenue à vous!\n#{player_id}, Entre ton prénom : "  #demande au joueur son pseudo
        @name = gets.chomp                       
        @symb = symb         #le symb va dépendre de l'argument (classique le "X" et le "O")
    end
end

class Case
  
  attr_accessor :status  #accède au status de l'attribut appelé

    def initialize(val)
        @status = val   #définie come un " " via la classe Board
    end
end

class Board 

    def initialize   #génère tous les cas dans des variables globales. A éviter dans le code...
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

    def display_board  #affiche la grille via le string. Pas trouver bcp mieux...
     #Le \n permet de passer à la ligne et le "\" est nécéssaire avant chaque caractères spéciaux (comme "\-|/")
        tab = " #{$c1.status} \| #{$c2.status} \| #{$c3.status} \n\-\-\-\|\-\-\-\|\-\-\- \n #{$c4.status} \| #{$c5.status} \| #{$c6.status} \n\-\-\-\|\-\-\-\|\-\-\- \n #{$c7.status} \| #{$c8.status} \| #{$c9.status} "
        puts tab
    end

    def display_tuto
        tab = " 1 \| 2 \| 3 \n\-\-\-\|\-\-\-\|\-\-\- \n 4 \| 5 \| 6 \n\-\-\-\|\-\-\-\|\-\-\- \n 7 \| 8 \| 9 "
        puts "\nComment jouer:\nChoisis une case en tapant sa lettre:"
        puts tab.colorize(:yellow)
        puts "----------------------------\n"
        sleep(2) #est une fonction qui ralentie le programme durant la période donnée. Découverte surprise mais intéressante
    end
end

class Game

    def initialize(i=0, p1=0, p2=0, name1="", name2="")  #se lance à l'appel de Game.new
        @turn = 0
        @choice_left = ["1","2","3","4","5","6","7","8","9"] #liste des cases non utilisées dans le cas ou le joueur derai une répétition
    end

    def game_start 

        puts "Initialisation ..."
        @players = []
        @players[0] = Player.new("Joueur 1 (Tu seras le rouge)", "❤".colorize(:red))
        @players[1] = Player.new("Joueur 2 (Tu seras le bleu)", "❤".colorize(:blue))

        puts"\n---------------------------"
        puts "\nBienvenue au Tic Tac Toe! !"
        puts "Joueur 1: #{@players[0].name.colorize(:red)} ------ Joueur 2: #{@players[1].name.colorize(:blue)}" 

        @board = Board.new  #créer le board
        @board.display_tuto

        while true #boucle infinie
            play_turn #méthode qui permet au joueur de faire son choix
            if win_combination_check == true   #vérifie les conditions de victoire
                puts "\nEt #{@players[@turn%2].name} gagne!"
                puts "Voulez-vous rejouer? (y/n)"
                answer = gets.chomp
            if answer == "y"
                $counter += 1
                game = Game.new #crée une nouvelle partie
				game.game_start #lance le nouveau jeu
			else break
            end

            elsif @turn == 8  #8 car pas plus de possibilité dans ce jeu (attention : ne fonctionnera pas avec des jeux plus complexes)
                puts "\nC'est une égalité!"
                puts "Voulez vous rejouer? (y/n)"
                answer = gets.chomp
            if answer == "y"
        		game = Game.new 
				game.game_start
            else 
                abort("Merci d'avoir joué !")
            end
        end
            @turn += 1 #passe au tour suivant
        end
    end

    def play_turn #méthode d'action des joueurs

        @current_player = @players[@turn%2].name  #Explication mon petit Alex : c'est une histoire de paire et d'impaire. Si c'est paire, c'est le joueur 1 sinon c'est le joueur 2 d'où le "%2"
        puts "\n C'est au tour de #{@current_player}, choisis une case:"
        @player_choice = ""

        while true
            @player_choice = gets.chomp

            unless @choice_left.include?(@player_choice) #permet de prévenir le joueur des cases disponibles
                puts "\nChoisis une case qui est libre! \n Il te reste : #{@choice_left}"
            else
                @choice_left.delete(@player_choice) #supprime la case choisie par le joueur
                break #permet de casser la boucle infinie
            end
        end

        case @player_choice #permet de modifier dans le board en fonction du choix du joueur
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

        @board.display_board #affiche le board modifié et c'est repartie pour la boucle
    end


    def win_combination_check

        @tab = [[$c1.status,$c2.status,$c3.status],[$c4.status,$c5.status,$c6.status],[$c7.status,$c8.status,$c9.status]]

        #vérifie les lignes et les colonnes
        (0..2).each do |i|
        if @tab[i][0] == @tab[i][1] && @tab[i][1] == @tab[i][2]
            return true unless @tab[i][0] == " " #retourne "true" sauf si une des première valeurs, quelques soit la ligne, est = rien

        elsif @tab[0][i] ==@tab[1][i] && @tab[1][i] == @tab[2][i]
            return true unless @tab[0][i] == " "#pareil pour les colonnes
        end
        end

        if ( @tab[0][0] == @tab[1][1] && @tab[1][1] == @tab[2][2] ) ||
            ( @tab[0][2] == @tab[1][1] && @tab[1][1] == @tab[2][0] )
            return true unless @tab[1][1] == " " #donne "true" sauf si la 5ème cases est vide "== ?"
        else
            return false
        end
    end

end

game = Game.new
game.game_start