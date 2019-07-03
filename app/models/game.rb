class Game < ApplicationRecord
  attr_accessor :random, :points

  validates_presence_of :duration, :random, on: :create

  before_create :generate_token
  before_create :generate_board

  scope :fresh, -> { where("created_at >= NOW() - CONCAT(duration, 'seconds')::interval") }
  scope :expired, -> { where("created_at < NOW() - CONCAT(duration, 'seconds')::interval") }

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

  def generate_board
    if ActiveModel::Type::Boolean.new.cast(random)
      self.board = Board.make_random_board_str
    end

    self.board ||= Board.make_test_board_str
  end
end
