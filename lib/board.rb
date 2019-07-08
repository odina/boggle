class Board
  attr_accessor :state

  ALLOWED_CHARS = (("A".."Z").map.to_a + ["*"]).freeze
  BOARD_SIZE = 4 # 4x4 board only
  BOARD_DIMENSIONS = BOARD_SIZE * BOARD_SIZE
  TEST_BOARD_FILE = "test_board.txt"

  class BoardNotRightDimensionsError < StandardError
    def message; "Board is not of the right dimensions!"; end
  end

  class BoardOfVaryingLengthsError < StandardError
    def message; "Board is of varying lengths!"; end
  end

  def self.make_random_board_str
    chars = []

    BOARD_DIMENSIONS.times { chars << ALLOWED_CHARS[rand(ALLOWED_CHARS.size)] }

    chars.join(", ")
  end

  def self.make_test_board_str
    file = "#{Rails.root}/lib/#{TEST_BOARD_FILE}"
    str = nil

    File.open(file, 'r').each do |line|
      str = line.chomp
    end

    str
  end

  def self.make_board_from_str(str)
    board_elements = str.gsub(/[^a-zA-Z\*]+/, '').split("").each_slice(BOARD_SIZE).to_a

    self.new(board_elements)
  end

  def initialize(state, boggle_tree=BOGGLE_TREE)
    @boggle_tree = boggle_tree
    @xmax = state.size
    @ymax = state[0].size

    state.each do |row|
      raise BoardOfVaryingLengthsError if row.size != @ymax
    end

    if (@xmax * @ymax != BOARD_DIMENSIONS)
      raise BoardNotRightDimensionsError
    end

    @state = state
  end

  def find_all_instances_of(letter)
    indices = []

    @state.each_with_index do |row,i|
      row.each_with_index do |e,j|
        indices << [i,j] if e && e == "*" || e.downcase == letter.downcase
      end
    end

    indices
  end

  def neighbor_iter(x, y)
    xrange = ([x-1, 0].max)..([x+1, @xmax-1].min)
    yrange = ([y-1, 0].max)..([y+1, @ymax-1].min)

    for i in xrange
      for j in yrange
        yield i, j if @state[i][j]
      end
    end
  end

  def valid?(word)
    return false if word.empty?
    return false if word.size > BOARD_DIMENSIONS

    resp = search(nil, word[0], word[1..-1], @boggle_tree[word[0]], [])

    resp[:found] && resp[:is_word]
  end

  def search(pos, curr_letter, rest_of_word, dict, exclude)
    resp = { found: false, is_word: false }

    indices_of_curr_letter = []

    # if the word has just started, look for all instances of the first letter
    if pos.nil?
      indices_of_curr_letter = find_all_instances_of(curr_letter)

    # otherwise, get all the neighbors of the current letter
    else
      neighbor_iter(*pos) do |x,y|
        next if exclude.member?([x,y])

        neighbor = @state[x][y]

        if neighbor == "*" || curr_letter == neighbor.downcase
          indices_of_curr_letter << [x,y]
        end
      end
    end

    # if this is the last letter, and the last letter is found as a neighbor, found!
    if !indices_of_curr_letter.empty? && rest_of_word.empty?
      return { found: true, is_word: dict && dict.is_word? }
    end

    # loop through all the letters, search for the remainder of the word recursively
    indices_of_curr_letter.each do |x,y|
      next_letter = rest_of_word[0]

      # if the tree at the current letter is non-existent, this is not a word,
      # so return { not_found, not_is_word }
      if dict.nil?
        return resp

      elsif dict.keys.member?(next_letter)
        resp = search([x,y], next_letter, rest_of_word[1..-1], dict[next_letter], exclude+[[x,y]])
      end

      return resp if resp[:found]
    end

    return resp
  end
end
