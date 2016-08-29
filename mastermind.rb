# Mastermind
#
# A sample project, created using the guidelines available at
# http://www.theodinproject.com/ruby-programming/oop?ref=lnav
#
# This version by James Thomson.

class Game
	attr_reader :code, :answer
	Player = Struct.new(:name)

	def initialize
		@codemaker = Player.new("Codemaker")
		@codebreaker = Player.new("Codebreaker")
		@counter = 1
		@code = Code.new()
		@answer = Array.new()
	end

	def play
		welcome_message
		@code.create_code
#		print_code	# For debugging purposes only
		start_playing
		show_result
	end

	def welcome_message
		puts "...................."
		puts "Welcome to Mastermind!"
		puts "...................."
		puts "#{@codebreaker.name}: You will have 12 turns to guess the correct code"
		puts "You will be told at the end of each turn how many colours you have right,"
		puts "and how many are in the correct location. Duplicates are allowed."
		puts ""
		puts "You can select from Blue, Red, Yellow, Green, Purple and Orange"
		puts "Please make your selection using the following syntax: "
		puts "Type 'blue red green orange' for Blue, Red, Green and Orange"
		puts "...................."
		puts "Let the game begin!"
	end

	def print_code
		print "Code is: "
		puts @code.random.inspect
	end

	def start_playing
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
		@answer = gets.chomp.downcase.split(" ")
#		puts @answer.inspect # For debugging purposes only
#		puts @answer.length # For debugging purposes only
		if check_for_errors == true
			@counter += 1
		else
			puts "Try again!"
		end
		check_for_win
		check_for_match
		#check_for_pos
		#check_for_col
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

		def create_code
			4.times do |x|
				x = @values.sample # selects random value from @values array
				@random << x # push random colour value into @random array
			end
		end
	end

end

game = Game.new
game.play