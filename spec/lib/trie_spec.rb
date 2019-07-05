require 'spec_helper'
require 'trie'

RSpec.describe Trie do
  before(:each) do
    @trie = Trie.new
    ['dad', 'dog', 'door'].each { |w| @trie.addword(w) }
  end

  it "is able to create a tree out of the 3 words" do
    expect(@trie['d']['a']['d']).not_to be_nil
    expect(@trie['d']['o']['g']).not_to be_nil
    expect(@trie['d']['o']['o']['r']).not_to be_nil
  end

  it "gives nil if the word doesn\'t exist" do
    expect { @trie['a']['b'] }.to raise_error(NoMethodError)
  end

  it "is able to determine if the whole thing is a word or not" do
    expect(@trie['d'].is_word?).to be false
    expect(@trie['d']['o']['g'].is_word?).to be true
  end
end
