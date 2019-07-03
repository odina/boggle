class Games::BaseSerializer < ActiveModel::Serializer
  attributes :id, :token, :duration, :board

  def duration
    object.duration.round(2)
  end
end
