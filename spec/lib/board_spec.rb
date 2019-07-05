require 'spec_helper'
require 'board'

RSpec.describe Board do
  before(:each) do
    @trie = Trie.new
    ['dad', 'dog', 'door'].each { |w| @trie.addword(w) }
  end

  it "is able to create a board out of a given string" do
    board_str = (["a", "b", "c", "d"] * 4).join(",")
    board = Board.make_board_from_str(board_str)

    expect(board.state.size).to eq(4)
  end

  it "throws an error if board string is not BOARD_SIZE * BOARD_SIZE" do
    expect { board = Board.make_board_from_str("A, B, C, D") }.to raise_error(RuntimeError)
  end

  it "is able to create a random board string" do
    str = Board.make_random_board_str
    str = str.gsub(/,\s+/,'')
    board_size = Board::BOARD_DIMENSIONS

    expect(str.size).to eq(board_size)
  end

  it "is able to create a test string" do
    test_str = "T, A, P, *, E, A, K, S, O, B, R, S, S, *, X, D"

    expect(Board.make_test_board_str).to eq(test_str)
  end

  describe "valid?" do
    before(:each) do
      board_str = <<-BOARD
        D A D B
        O G X Y
        O * R K
        N G H T
      BOARD

      @board = Board.make_board_from_str(board_str)
    end

    it "is able to find defined words in the board" do
      expect(@board.valid?("dad")).to be true
      expect(@board.valid?("dog")).to be true
      expect(@board.valid?("door")).to be true
    end

    it "returns false for words not in board" do
      expect(@board.valid?("wrong")).to be false
      expect(@board.valid?("word")).to be false
    end

    it "returns false for partial words" do
      expect(@board.valid?("d")).to be false
      expect(@board.valid?("do")).to be false
    end
  end
end
