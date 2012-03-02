class CreateUserKeys < ActiveRecord::Migration
  def change
    create_table :user_keys do |t|
      t.string :key
      t.references :user

      t.timestamps
    end
    add_index :user_keys, :user_id
  end
end
