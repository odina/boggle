class GamePresenter
  attr_accessor :games, :game

  def initialize(games:nil, game:nil)
    @games = games
    @game = game
  end

  def game_overview
    { id: @game.id, token: @game.token, time_left: "#{@game.time_left.round(2)} seconds" }
  end
end
