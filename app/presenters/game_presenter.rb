class GamePresenter
  attr_accessor :games, :game, :board, :errors

  def initialize(games:nil, game:nil)
    @games = games
    @game = game
    @errors = nil
    @board = board unless @games || @game
  end

  def has_games?
    @games && @games.any?
  end

  def has_errors?
    !!@errors
  end

  def game_overview
    { id: @game.id, token: @game.token, time_left: "#{@game.time_left.round(2)} seconds" }
  end

  def board
    @game ||= @games.first

    begin
      @board = Board.make_board_from_str(@game.board)
    rescue Board::BoardOfVaryingLengthsError,
           Board::BoardNotRightDimensionsError => e
      @errors = e.message
    end
  end

  def points
    @game.game_results.first.try(:points) || 0
  end
end
