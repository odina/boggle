class Board
  attr_accessor :state

  ALLOWED_CHARS = (("A".."Z").map.to_a + ["*"]).freeze
  BOARD_SIZE = 4 # 4x4 board only
  TEST_BOARD_FILE = "test_board.txt"

  def self.make_board_from_str(str)
    board_elements = str.split(/,\s*/).each_slice(BOARD_SIZE).to_a

    self.new(board_elements)
  end

  def self.make_random_board
    chars = []

    (BOARD_SIZE * BOARD_SIZE).times { chars << ALLOWED_CHARS[rand(ALLOWED_CHARS.size)] }

    self.make_board_from_str(chars.join(","))
  end

  def self.make_test_board
    file = "#{Rails.root}/lib/#{TEST_BOARD_FILE}"
    str = nil

    File.open(file, 'r').each do |line|
      str = line
    end

    self.make_board_from_str(str)
  end

  def initialize(state)
    @xmax = state.size
    @ymax = state[0].size

    state.each do |row|
      raise "Board rows are of varying lengths" if row.size != @ymax
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
    word = word.downcase
    letter = word[0]

    find_all_instances_of(letter).each do |x,y|
      resp = search(BOGGLE_TREE[letter], word[1..-1], [x,y], [[x,y]])

      return true if resp
    end

    return false
  end

  def search(dict, word, pos, exclude_indices)
    return true if word.empty? && dict.is_word?

    letter = word[0]
    rest_of_word = word[1..-1]

    neighbor_iter(*pos) do |nx, ny|
      next if exclude_indices.member?([nx,ny])
      neighbor = @state[nx][ny]
      matched = neighbor == "*" || letter == neighbor.downcase

      if matched
        if new_dict = dict[letter]
          if search(new_dict, rest_of_word, [nx,ny], exclude_indices.push([nx,ny]))
            return true
          else
            exclude_indices.delete([nx,ny])
          end
        end
      end
    end

    return false
  end
end
