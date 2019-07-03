class GamePresenter
  attr_accessor :games, :game, :board

  def initialize(games:nil, game:nil)
    @games = games
    @game = game
  end

  def has_games?
    @games && @games.any?
  end

  def game_overview
    { id: @game.id, token: @game.token, time_left: "#{@game.time_left.round(2)} seconds" }
  end

  def board
    @game ||= @games.first
    @board = Board.make_board_from_str(@game.board)
  end
end
