class Game < ApplicationRecord
  attr_accessor :random

  validates_presence_of :duration

  before_create :generate_token

  scope :fresh, -> { where("TIMESTAMPDIFF(SECOND, created_at, NOW()) < duration") }
  scope :expired, -> { where("TIMESTAMPDIFF(SECOND, created_at, NOW()) >= duration") }

  def time_since_creation
    Time.now - self.created_at
  end

  def expired?
    time_since_creation > duration
  end

  def fresh?
    !expired?
  end

  def time_left
    if expired?
      return 0
    else
      duration - time_since_creation
    end
  end

  private

  def generate_token
    self.token = SecureRandom.hex
  end
end
