class PlayBoggle
  include Interactor

  def call
    context.fail!(errors: "Game could not be found!") unless game = context.game
    context.fail!(errors: "Game has expired!", redirect: true) if game.expired?

    begin
      board = Board.make_board_from_str(context.game.board)
    rescue Board::BoardOfVaryingLengthsError,
           Board::BoardNotRightDimensionsError => e
      context.fail!(errors: e.message)
    end

    valid = false

    if board.valid?(context.word)
      if game_result.exists?(context.word)
        context.fail!(errors: "Word \"#{context.word}\" has already been found!")
      else
        game_result.add_found_word(context.word)
      end
    else
      context.fail!(errors: "Word \"#{context.word}\" not found in board")
    end

    context.game_result = game_result
  end

  private

  def game_result
    @game_result ||= context.game.game_results.find_or_create_by(game_id: context.game.id)
  end
end
