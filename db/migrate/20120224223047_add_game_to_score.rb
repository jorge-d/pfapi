class AddGameToScore < ActiveRecord::Migration
  def change
    add_column :scores, :game_id, :integer

    add_index :scores, :game_id
  end
end
