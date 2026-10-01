class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service
  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(word)
    @guesses = ''
    @wrong_guesses = ''
    @word = word
  end

  def guess(letter)
    raise ArgumentError unless letter.is_a?(String) && letter.match?(/\A[a-zA-Z]\z/)

    letter = letter.downcase
    return false if @guesses.include?(letter) || @wrong_guesses.include?(letter)

    if @word.include?(letter)
      @guesses += letter
    else
      @wrong_guesses += letter
    end
    true
  end

  def word_with_guesses
    @word.chars.map do |letter|
      @guesses.include?(letter) ? letter : '-'
    end.join
  end

  def check_win_or_lose
    return :win if @word.chars.all? { |letter| @guesses.include?(letter) }
    return :lose if @wrong_guesses.length >= 7

    :play
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://esaas-randomword-27a759b6224d.herokuapp.com/RandomWord') 
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http| 
      return http.post(uri, "").body
    end
  end
end
