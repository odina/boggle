class GameResult < ApplicationRecord
  belongs_to :game

  def add_found_word(word)
    found_words << word unless exists?(word)
    self.save
  end

  def points
    found_words.join("").size
  end

  def exists?(word)
    found_words.member?(word)
  end
end
