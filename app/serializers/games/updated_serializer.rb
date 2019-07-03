class Games::UpdatedSerializer < Games::BaseSerializer
  attributes :points, :time_left

  def points
    @game_result = object.game_results.first
    @game_result.try(:points) || 0
  end
end
