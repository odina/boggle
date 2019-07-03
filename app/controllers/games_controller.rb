class GamesController < ApplicationController
  def index
    # welcome
  end

  def show
    @game = Game.find_by(id: params[:id])

    if @game
      render plain: @game
    else
      render plain: "No game found!"
    end
  end

  def update
    # play the game
  end
end
