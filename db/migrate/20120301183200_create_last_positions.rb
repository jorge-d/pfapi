class CreateLastPositions < ActiveRecord::Migration
  def change
    create_table :last_positions do |t|
      t.references :user
      t.references :zone

      t.timestamps
    end
    add_index :last_positions, :user_id
    add_index :last_positions, :zone_id
  end
end
