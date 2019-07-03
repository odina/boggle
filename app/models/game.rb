class Game < ApplicationRecord
  attr_accessor :random

  validates_presence_of :duration, :random

  before_create :generate_token

  # TODO: Randomize if params[:random] == true on create

  private

  def generate_token
    self.token = SecureRandom.hex
  end
end
