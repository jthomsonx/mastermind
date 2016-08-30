# Mastermind
#
# A sample project, created using the guidelines available at
# http://www.theodinproject.com/ruby-programming/oop?ref=lnav
#
# This version by James Thomson.

class Game
	attr_reader :code, :answer
	Player = Struct.new(:name, :type)

	def initialize
		@counter = 1
		@code = Code.new()
		@answer = Array.new()
	end

	def play
		welcome_message
		player_select
		instructions
		if @codemaker.type == :computer
			@code.computer_code
		elsif @codemaker.type == :human
			@code.human_code
			print_code
		end
#		print_code	# For debugging purposes only
		start_playing
		show_result
	end

	def welcome_message
		puts "...................."
		puts "Welcome to Mastermind!"
		puts "...................."
	end

	def player_select
		print "Please enter your name: "
		name = gets.chomp
		print "Please type 'A' to be the CodeBreaker, or 'B' for CodeMaker: "
		type = gets.chomp
		if type.downcase == "a"
			@codebreaker = Player.new(name, :human)
			@codemaker = Player.new("Computer", :computer)
		else
			@codemaker = Player.new(name, :human)
			@codebreaker = Player.new("Computer", :computer)
		end
	end

	def instructions
		puts ""
		puts "...................."
		puts "Mastermind is a game of logic, where the objective is to guess a random"
		puts "code of four colours."
		puts ""
		if @codebreaker.type == :human
			puts "#{@codebreaker.name}: You will have 12 turns to guess the correct code"
			puts "You will be told at the end of each turn how many colours you have right,"
			puts "and how many are in the correct location. Duplicates are allowed."
			puts ""
			puts "You can select from Blue, Red, Yellow, Green, Purple and Orange"
			puts "Please make your selection using the following syntax: "
			puts "e.g. Type 'blue red green orange' for Blue, Red, Green and Orange"
			puts ""
		elsif @codemaker.type == :human
			puts "#{@codemaker.name}: You will enter a secret code of four colours which"
			puts "#{@codebreaker.name} will have 12 turns to guess correctly."
			puts ""
			puts "Please make your code selection using the following syntax: "
			puts "e.g. Type 'blue red green orange' for Blue, Red, Green and Orange"
			puts ""
		end
	end

	def print_code
		print "Code is: "
		puts @code.random.inspect
	end

	def start_playing
		puts "...................."
		puts "Let's start the game!"
		sleep 2
		turns until game_over
	end

	def turns
		puts ""
		puts "Turn: #{@counter}, #{@codebreaker.name}"
		if @counter == 1
			print "Please select four colours, e.g. 'blue orange blue green': "
		else
			print "Please select four colours: "
		end
		if @codebreaker.type == :human
			human_guess
		elsif @codebreaker.type == :computer
			computer_guess
		end
		if check_for_errors == true
			@counter += 1
			check_for_win
			check_for_match
		else
			puts "Try again!"
		end
		@answer = []
	end

	def human_guess
		@answer = gets.chomp.downcase.split(" ")
	end

	def computer_guess
		until @answer.length == 4
			@answer << @code.values.sample
		end
		puts @answer.to_s
		sleep 2		
	end

	def game_over
		@counter > 12 || @winner
	end

	def check_for_win
		@winner = @codebreaker if @answer == @code.random
	end

	def show_result
		puts ""
		if @winner != nil
			puts "Congratulations #{@winner.name}. You won the game!"
		else
			puts "Sorry #{@codebreaker.name}. Better luck next time!"
			puts "#{@codemaker.name} won this round!"
		end
	end

	def check_for_errors
		if @answer.length == 4 && (@answer - @code.values).empty?
			return true
		else
			# Check @answers array contains exactly 4 values
			puts "Error: Incorrect number of colours: #{@answer.length} instead of 4." unless @answer.length == 4 
			# Check @answers array only contains colours in @code.values
			puts "Error: Incorrect colour value(s) chosen!" unless (@answer - @code.values).empty?
			return false
		end
	end

#	def check_for_pos
#		pos = 0
#		@answer.each_with_index do |val, idx|
#			pos += 1 if @answer[idx] == @code.random[idx]
#		end
#		puts "#{pos} in the correct position"
#	end

#	def check_for_col
#		col = 0
#		@code.random.each do |value|
#			if @answer.include?(value)
#				col += 1
#				@answer.delete_at(@answer.index(value))
#			end
#		end
#		puts "#{col} colour(s) correct!"
#	end

	# Combines both check_for_pos and check_for_col into one method
	def check_for_match
		col = 0
		pos = 0
		@answer.each_with_index do |val, idx|
			pos += 1 if @answer[idx] == @code.random[idx]
		end
		@code.random.each do |val|
			if @answer.include?(val)
				col += 1
				@answer.delete_at(@answer.index(val))
			end
		end
		puts "#{col} colours correct, with #{pos} in the correct position."
	end

	class Code
		attr_reader :random, :values

		def initialize
			@random = Array.new()
			@values = ["blue", "red", "yellow", "green", "purple", "orange"]
		end

		def computer_code
			4.times do |x|
				x = @values.sample # selects random value from @values array
				@random << x # push random colour value into @random array
			end			
		end

		def human_code
			while true
				print "Please select a four colour code. Remember, duplicates are allowed: "
				@random = gets.chomp.downcase.split(" ")
#				puts @random.inspect 	# For debugging only
				return false unless human_code_error_check == true
			end
		end

		# Should be able to refactor this along with "check_for_error" method above.
		def human_code_error_check
			if @random.length == 4 && (@random - @values).empty?
				return false
			else
				puts "Error: Incorrect number of colours: #{@random.length} instead of 4." unless @random.length == 4 
				puts "Error: Incorrect colour value(s) chosen!" unless (@random - @values).empty?
				return true
			end
		end
	end

end

game = Game.new
game.play