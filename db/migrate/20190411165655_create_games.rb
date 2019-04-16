class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.integer :player1_id
      t.integer :player2_id
      t.integer :turn
      t.boolean :finished
      t.integer :winner
      t.string  :game_state
      t.timestamps
    end
  end
end
