class GamesController < ApplicationController
  def index
    @presenter = GamePresenter.new(games: Game.fresh)
  end

  def show
    @game = Game.find_by(id: params[:id])
    @presenter = GamePresenter.new(game: @game)
  end

  def update
    @game = Game.find_by(id: params[:id])
    @presenter = GamePresenter.new(game: @game)
    @board = Board.make_board_from_str(@game.board)

    if @board.valid?(game_params[:word])
      flash[:success] = "Valid word #{params[:word]}"
    else
      flash[:error] = "Couldn't find word #{params[:word]} in boggle"
    end

    render :show
  end

  private

  def game_params
    params[:game].permit(:token, :word)
  end
end