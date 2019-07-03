class GamesController < ApplicationController
  def index
    @presenter = GamePresenter.new(games: Game.fresh)
  end

  def show
    @game = Game.find_by(id: params[:id])
    @presenter = GamePresenter.new(game: @game)
  end

  def update
    # play the game
  end
end
