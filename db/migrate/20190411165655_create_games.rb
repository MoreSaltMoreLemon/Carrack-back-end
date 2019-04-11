class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.integer :player1
      t.integer :player2
      t.integer :turn
      t.boolean :finished
      t.integer :winner

      t.timestamps
    end
  end
end
