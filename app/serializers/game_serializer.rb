class GameSerializer < ActiveModel::Serializer
  attributes :id, :turn, :finished, :winner, :game_state
  belongs_to :player1, class_name: 'Player', foreign_key: :player1_id
  belongs_to :player2, class_name: 'Player', foreign_key: :player2_id
end
