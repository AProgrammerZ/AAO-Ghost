class Player
    attr_reader :name

    def initialize(name)
        @name = name
    end

    def guess
        print "#{@name}, please enter a guess: "
        gets.chomp
    end

    def alert_invalid_guess
        puts "Invalid guess. Please try again."
    end
end