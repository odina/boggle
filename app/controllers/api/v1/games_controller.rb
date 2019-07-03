class Api::V1::GamesController < Api::BaseController
  def index
    render json: { meth: "index" }
  end

  def create
    render json: { meth: "create" }
  end

  def update
    render json: { meth: "update" }
  end

  def show
    render json: { meth: "show" }
  end
end
