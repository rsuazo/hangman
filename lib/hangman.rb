class Game
  attr_accessor :secret_word, :guesses, :guess_word, :wrong_guesses, :player

  def initialize(player_class)
    @secret_word = get_word
    @guess_word = []
    @wrong_guesses = []
    @guesses = 7
    @player = player_class.new("Robert", self)
  end

  def get_word
    lines = File.readlines "5desk.txt"
    loop do
      temp_word = lines.sample.chomp
      if temp_word.length.between?(5, 13)
        return temp_word.downcase
      end 
    end
  end

  def display_secret_word
    secret_word.split('').each { |char| 
    guess_word.include?(char) ? (print "#{char.upcase}") : (print "_ ") }
    print "\n\n"
  end

  def wrong_guess
    @guesses > 0 ? self.guesses -= 1 : game_over
  end

  def game_over
    puts "The secret word was #{@secret_word.upcase}\n"
    puts "Game Over!"
  end

  def show_guesses
    puts "You have #{guesses} guesses left!\n"
  end

  def win?(guess)
    if guess == @secret_word
      puts "You Win!"
    end
  end

  def get_choice
    loop do
      puts "Make your selection!: (S)ave Game | (L)oad Game | (G)uess Letter"
      choice = gets.chomp.downcase
      if choice == "s"
        self.save_game
      elsif choice == "l"
        self.load_game
        
      elsif choice == "g"
        player.choose_letter
        break
      else
        puts "Oops, that is an invalid choice, try again!"
      end
    end
  end

  def save_game
    fname = "hangman_save.txt"
    somefile = File.open(fname, "w")
    somefile.puts @secret_word
    somefile.puts @guesses
    somefile.puts @wrong_guesses.join(",")
    somefile.puts @guess_word.join(",")
    somefile.close
  end

  def load_game
    fname = "hangman_save.txt"
    file = File.open(fname, "r")

    @secret_word = file.readline.chomp
    @guesses = file.readline.chomp
    @wrong_guesses = file.readline.chomp
    @guess_word = file.readline.chomp
    @guesses = @guesses.to_i
    @wrong_guesses = @wrong_guesses.split(",")
    @guess_word = @guess_word.split(",")
    print @secret_word, @guesses, @wrong_guesses, @guess_word
    
  end

  def save_state
    puts "Do you want to save or load the game?"
    state = gets.chomp.downcase
    if state == "s"
      self.save_game
    elsif state == 'l'
      self.load_game
    else
      puts "try again!"
    end
  end


end

class Player
  attr_accessor :name, :choice, :game
  def initialize(name, game)
    @name = name
    @choice = ''
    @game = game
  end

  def choose_letter
    loop do
      puts "\n\nSelect your guess!\n"
      @choice = gets.downcase.chomp
      if @choice.match /\A[a-z]\z/
        if game.wrong_guesses.any? {|word| word == @choice}
          puts "You already chose that letter, try again!\n"
        else
          break
        end
      else
        puts "That wasn't a letter, try again!\n"
      end
    end
  end

  def access_var
    puts "this is the instance variable: #{game.secret_word}"
  end

  def invalid_choice
    # if 
    # # if @choice.split('').any? {|char| char == }
  end
end

game = Game.new(Player)


puts "Hi #{game.player.name}! Let's Play HangMan!"
game.player.access_var


while game.guesses > 0
  game.show_guesses
  game.display_secret_word

  game.get_choice

  # game.player.choose_letter
  times = 0


  if game.secret_word.split('').any? {|char| char == game.player.choice}
    game.secret_word.split('').each.with_index {|val,index|
      if val == game.player.choice
        game.guess_word[index] = val
        times += 1
      end}
      print "\n'#{game.player.choice.upcase}' shows up #{times} times!\n\n"
    
  else
    print "Sorry, '#{game.player.choice.upcase}' isn't here!\n\n" 
    game.guesses -= 1
    game.wrong_guesses << game.player.choice
    print "These are the guesses you already tried: \n#{game.wrong_guesses}\n"
  end

  if game.guess_word.join == game.secret_word
    print "Game Over!"
    exit
  end
end

game.game_over