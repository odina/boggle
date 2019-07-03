class Games::UpdatedSerializer < Games::BaseSerializer
  attributes :points, :time_left

  def points
    object.points || 0
  end
end
