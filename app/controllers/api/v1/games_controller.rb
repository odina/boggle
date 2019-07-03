class Api::V1::GamesController < Api::BaseController
  skip_before_action :verify_authenticity_token

  def create
    @game = Game.new(create_game_params)

    if @game.save
      render json: Games::BaseSerializer.new(@game).as_json, status: 201
    else
      render json: { message: @game.errors.full_messages }, status: 400
    end
  end

  def update
    @game = Game.fresh.find_by_id_and_token(params[:id], params[:token])

    answer = PlayBoggle.call(game: @game, word: params[:word])

    if answer.success?
      render json: Games::UpdatedSerializer.new(@game).as_json, status: 200
    else
      render json: { message: answer.errors }, status: 400
    end
  end

  def show
    @game = Game.find_by(id: params[:id])

    if @game
      render json: Games::UpdatedSerializer.new(@game).as_json, status: 200
    else
      render json: { message: "Game with id #{params[:id]} not found" }, status: 404
    end
  end

  private

  def create_game_params
    params.permit(:duration, :board, :random)
  end
end
