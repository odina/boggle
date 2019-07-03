class Api::V1::GamesController < Api::BaseController
  skip_before_action :verify_authenticity_token

  def index
    render json: { method: "index" }
  end

  def create
    @game = Game.new(params)

    if @game.save
      render json: { success: true }
    else
      render json: { errors: @game.errors.full_messages }
    end
  end

  def update
    @game = Game.find_by(id: params[:id])

    answer = PlayBoggle.call(game: @game, word: params[:word])

    if answer.correct
      render json: { success: true, message: "valid!"}
    else
      render json: { success: true, message: "INVALID!" }
    end
  end

  def show
    @game = Game.find_by(id: params[:id])

    render json: { game: @game }
  end
end
