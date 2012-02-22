class CreateZones < ActiveRecord::Migration
  def change
    create_table :zones do |t|
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
