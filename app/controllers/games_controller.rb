class GamesController < ApplicationController
  def index
    @presenter = GamePresenter.new(games: Game.fresh)
  end

  def show
    @game = Game.find_by(id: params[:id])

    if @game
      if @game.fresh?
        @presenter = GamePresenter.new(game: @game)
      else
        flash[:error] = "Game has expired!"
        redirect_to games_path
      end
    else
      flash[:error] = "Game not found!"
      redirect_to games_path
    end
  end

  def update
    @game = Game.find_by(id: params[:id])

    answer = PlayBoggle.call(game: @game, word: game_params[:word])

    @presenter = GamePresenter.new(game: @game)

    if answer.success?
      flash[:success] = "Good job! The word \"#{game_params[:word]}\" was found in the boggle."
    else
      flash[:error] = answer.errors
    end

    if answer.redirect
      redirect_to root_path
    else
      render :show
    end
  end

  private

  def game_params
    params[:game].permit(:id, :token, :word)
  end
end
