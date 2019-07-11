require 'spec_helper'
require 'json'

RSpec.describe Api::V1::GamesController, type: :controller do
  include AuthHelper

  before(:each) do
    http_login
  end

  def assert_error(response, status)
    expect(response.code.to_i).to eq status
    json = JSON.parse(response.body)
    expect(json).to have_key('message')
  end

  def assert_not_success(response)
    expect(response.code.to_i.to_i).not_to eq 200
    json = JSON.parse(response.body)
    expect(json).to have_key('message')
  end

  it 'creates game with random board' do
    duration = 100
    post :create, params: { random: true, duration: duration }

    expect(response.code.to_i).to eq 201

    json = JSON.parse(response.body)

    expect(json).to have_key('id')
    expect(json).to have_key('token')
    expect(json).to have_key('board')
    expect(json['duration']).to eq duration
  end

  it 'creates game with specified board' do
    duration = 100
    board = "A, C, E, D, L, *, G, *, E, *, H, T, G, A, F, K"

    response = post(:create, params: { random: false, duration: duration, board: board })
    expect(response.code.to_i.to_i).to eq 201

    json = JSON.parse(response.body)

    expect(json).to have_key('id')
    expect(json).to have_key('token')
    expect(json['board']).to eq board
    expect(json['duration']).to eq duration
  end

  it 'creates game with test board' do
    duration = 1000
    response = post(:create, params: { random: false, duration: duration })
    expect(response.code.to_i.to_i).to eq 201

    json = JSON.parse(response.body)

    expect(json).to have_key('id')
    expect(json).to have_key('token')
    expect(json['board']).to eq('T, A, P, *, E, A, K, S, O, B, R, S, S, *, X, D')
    expect(json['duration']).to eq duration
  end

  it 'creates game with invalid input' do
    duration = 1000
    response = post(:create, params: { duration: duration })
    assert_error(response, 400)
  end

  it 'plays game with correct word' do
    response = post(:create, params: { random: false, duration: 1000 })
    game = JSON.parse(response.body)

    response = put(:update, params: { id: game["id"], token: game['token'], word: 'tap' })
    expect(response.code.to_i).to eq 200

    json = JSON.parse(response.body)

    expect(json['id']).to eq game['id']
    expect(json['token']).to eq game['token']
    expect(json['board']).to eq game['board']
    expect(json['points']).to eq 3
    expect(json).to have_key('time_left')
  end

  it 'plays game with wrong word' do
    response = post(:create, params: { random: false, duration: 1000 })
    game = JSON.parse(response.body)

    response = put(:update, params: { id: game['id'], token: game['token'], word: 'thisiswrong' })
    assert_not_success(response)
  end

  it 'plays outdated game' do
    duration = 1
    response = post(:create, params: { random: false, duration: duration })
    game = JSON.parse(response.body)

    sleep(duration + 1)

    response = put(:update, params: { id: game['id'], token: game['token'], word: 'tap' })

    assert_not_success(response)
  end

  it 'shows game info' do
    response = post(:create, params: { random: false, duration: 1000 })
    game = JSON.parse(response.body)

    response = get(:show, params: { id: game['id'] })
    expect(response.code.to_i).to eq 200

    json = JSON.parse(response.body)

    expect(json['id']).to eq game['id']
    expect(json['token']).to eq game['token']
    expect(json['board']).to eq game['board']
    expect(json['points']).to eq 0
    expect(json).to have_key('time_left')
  end

  it 'displays error when game is not found' do
    response = post(:create, params: { random: false, duration: 1000 })
    game = JSON.parse(response.body)

    response = get(:show, params: { id: -1 })
    assert_error(response, 404)
  end

  it 'makes a board with character Qu playable' do
    duration = 100

    board = <<-BOARD
      Qu, C, E, D,
      L, *, G, *,
      E, *, H, T,
      G, A, F, K
    BOARD

    response = post(:create, params: { random: false, duration: duration, board: board })
    game = JSON.parse(response.body)

    response = put(:update, params: { id: game['id'], token: game['token'], word: 'quote' })
    json = JSON.parse(response.body)

    expect(json['id']).to eq game['id']
    expect(json['token']).to eq game['token']
    expect(json['board']).to eq game['board']
    expect(json['points']).to eq 5
    expect(json).to have_key('time_left')
  end

  it 'fails when trying to play a boggle with invalid character' do
    duration = 100

    board = <<-BOARD
      Wrong, C, E, D,
      L, *, G, *,
      E, *, H, T,
      G, A, F, K
    BOARD

    response = post(:create, params: { random: false, duration: duration, board: board })
    game = JSON.parse(response.body)

    response = put(:update, params: { id: game['id'], token: game['token'], word: 'quote' })

    assert_not_success(response)
  end
end
