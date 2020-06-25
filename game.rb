require_relative "./player.rb"
require 'set'

class Game
    attr_reader :current_player, :previous_player, :losses

    def initialize(num)
        @players = []
        num.times { |i| @players << Player.new("Player #{i+1}") }
        @fragment = ""
        @dictionary = File.read("./dictionary.txt").split.to_set
        @current_player = @players.first
        @previous_player = @players.first
        @losses = @players.each_with_object(0).to_h
    end

    def next_player!              
        if @current_player == @players.last
            @current_player = @players.first
            @previous_player = @players.last
        else
            cp_idx = @players.index(@current_player)
            @current_player = @players[cp_idx + 1]
            @previous_player = @players[cp_idx]
        end
    end

    def valid_play?(string)
        return false if !("a".."z").to_a.include?(string)
        return false if !@dictionary.to_a.any? { |word| word.start_with?(@fragment + string)}
        true
    end

    def take_turn(player)
        letter = ""
        until valid_play?(letter)
            letter = @current_player.guess
            player.alert_invalid_guess if !valid_play?(letter)         
        end
        @fragment += letter
        if @dictionary.include?(@fragment)
            puts "\n#{player.name} loses"
            puts            
            @losses[player] += 1
            @current_player = @players.first
            @previous_player = player
            return false
        end 
    end

    def record(player)
        string = "GHOST"
        value = @losses[player]       
        string[0..value-1] if value > 0 
    end

    def play_round
        until take_turn(@current_player) == false
            next_player!
        end
        @losses.each do |player,value|
            puts "#{player.name}: #{record(player)}"
            if value == 5
                puts "\n#{player.name} is eliminated"
                @losses.delete(player)
                @players.delete(player)
                @current_player = @players.first
                @previous_player = player                                               
            end
        end
        if @losses.keys.length == 1    
            puts "#{@losses.keys[0].name} wins!" 
            return true
        end
        @fragment = ""
        false
    end

    def run
        puts until play_round == true
        true
    end
end

game = Game.new(3)
game.run