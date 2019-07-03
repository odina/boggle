class Games::UpdatedSerializer < Games::BaseSerializer
  attributes :points, :time_left

  def points
    @game_result = GameResult.find_by(game_id: object.id)
    @game_result.try(:points) || 0
  end
end
