class PlayBoggle
  include Interactor

  def call
    context.fail!(errors: "Game could not be found") unless game = context.game
    context.fail!(errors: "Game has expired") if game.expired?

    board = make_board
    context.board = board

    word = "eight" # TODO: example

    board.valid?(word)
  rescue # all
    context.fail!(errors: "Failed to create board out of the game")
  end

  private

  def make_board
    Board.make_board_from_str(context.game.board)
  end
end
