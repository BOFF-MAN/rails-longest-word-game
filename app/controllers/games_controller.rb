require "json"
require "rest-client"

class GamesController < ApplicationController

  SCORES = []
  WORDS = []

  def new
    @letters = []
    @scores = SCORES
    @words = WORDS
    alphabet = %w{ A B C D E F G H I J K L M N O P Q R S T U V W X Y Z}
    10.times do
      @letters << alphabet.sample
    end
    @letters
    @scores
    @words
  end

  def score
    @answer = ""
    @score = 0
    submission = params[:word].upcase
    WORDS << submission
    if !included?(submission, params[:letters])
      @answer = "Sorry, but #{submission} cannot be made with made with #{params[:letters]}"
    elsif !check_word(params[:word])
      @answer = "Sorry, but #{submission} is not a valid English word"
    else
      @answer = "Congratulations! #{submission} is a valid English word!"
      @score = submission.length * 3
    end
    SCORES << @score
    return @answer, @score
  end

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter)}
  end

  def check_word(word)
    response = RestClient.get "https://wagon-dictionary.herokuapp.com/#{word}"
    clean_result = JSON.parse(response)
    clean_result["found"]
  end
end
