class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.
  attr_accessor :word, :guesses, :wrong_guesses

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
    @current_letter = ''
  end

  def guess(letter)
    @current_letter = letter.to_s.downcase

    throw ArgumentError if invalid_character?


    return false if been_guessed?

    update_guesses

    true
  end

  def word_with_guesses
    word.chars.map { |char| guesses.include?(char) ? char : '-' }.join('')
  end

  def check_win_or_lose
    @status = :play
    @status = :win if word_with_guesses == word

    @status = :lose if wrong_guesses.size > 6

    @status
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

  private

  def been_guessed?
    guesses.include?(@current_letter) || wrong_guesses.include?(@current_letter)
  end

  def invalid_character?
    !('a'..'z').include? @current_letter
  end

  def update_guesses
    return self.guesses = guesses + @current_letter if word.include? @current_letter

    self.wrong_guesses = wrong_guesses + @current_letter
  end
end
