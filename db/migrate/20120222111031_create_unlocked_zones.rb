class CreateUnlockedZones < ActiveRecord::Migration
  def change
    create_table :unlocked_zones do |t|
      t.references :user
      t.references :zone

      t.timestamps
    end
    add_index :unlocked_zones, :user_id
    add_index :unlocked_zones, :zone_id
  end
end
