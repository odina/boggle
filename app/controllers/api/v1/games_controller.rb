class Api::V1::GamesController < Api::BaseController
  skip_before_action :verify_authenticity_token

  def index
    render json: { method: "index" }
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
    render json: { method: "update" }
  end

  def show
    @game = Game.find_by(id: params[:id])

    resp = PlayBoggle.call(game: @game)

    if resp.failure?
      render json: { errors: resp.errors }
    else
      render json: { success: true, board: resp.board }
    end
  end

  private

  def game_params
    params.permit(:duration, :random, :board)
  end
end
