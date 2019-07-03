class BoggleTree
  attr_reader :dict

  def initialize
    @dict = Trie.new
    file = "#{Rails.root}/config/dictionary.txt"

    File.open(file, 'r') do |f|
      f.each do |word|
        @dict.addword(word.downcase.chomp)
      end
    end
  end
end

BOGGLE_TREE = BoggleTree.new.dict
