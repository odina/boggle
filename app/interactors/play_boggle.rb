class PlayBoggle
  include interactor

  def call
    game = context.game
    board = Board.new(game.board)
  end
end
