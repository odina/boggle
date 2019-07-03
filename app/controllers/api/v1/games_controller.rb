class Api::V1::GamesController < Api::BaseController
  skip_before_action :verify_authenticity_token

  def index
    render json: { meth: "index" }
  end

  def create
    @game = Game.new(game_params)

    if @game.save
      render json: { success: true }
    else
      render json: { errors: @game.errors.full_messages }
    end
  end

  def update
    render json: { meth: "update" }
  end

  def show
    @game = Game.find_by(id: params[:id])

    if @game
      render json: { game: @game }
    else
      render json: { errors: "No such game found!" }
    end
  end

  private

  def game_params
    params.permit(:duration, :random, :board)
  end
end
