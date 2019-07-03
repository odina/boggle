class PlayBoggle
  include Interactor

  def call
    context.fail!(errors: "Game could not be found") unless game = context.game
    context.fail!(errors: "Game has expired") if game.expired?

    board = Board.make_board_from_str(context.game.board)

    context.correct = board.valid?(context.word)
  end
end
