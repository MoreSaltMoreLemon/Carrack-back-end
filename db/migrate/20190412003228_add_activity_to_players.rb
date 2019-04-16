class AddActivityToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :activity, :string, default: 'inactive'
  end
end
