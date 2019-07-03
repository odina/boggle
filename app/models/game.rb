class Game < ApplicationRecord
  attr_accessor :random

  validates_presence_of :duration

  before_create :generate_token

  # TODO: Randomize if params[:random] == true on create

  def expired?
    Time.now - self.created_at > self.duration
  end

  private

  def generate_token
    self.token = SecureRandom.hex
  end
end
