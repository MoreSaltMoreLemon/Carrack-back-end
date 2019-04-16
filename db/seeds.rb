require 'faker'

Player.create(username: 'allen', password: 'password')

10.times do 
  Player.create(
    username: Faker::Internet.username,
    email: Faker::Internet.email,
    password: 'password',
    activity: 'active'
  )
end

2.times do |i|
  puts "TEST" + i.to_s
  Game.create(
    player1_id: Player.find(i + 2).id,
    player2_id: Player.find(i + 4).id,
    turn: 0,
    finished: false,
    game_state: ''
  )
end

2.times do |i|
  Game.create(
    player1_id: Player.find(i + 8).id,
    player2_id: nil,
    turn: 0,
    finished: false,
    game_state: ''
  )
end