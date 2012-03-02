class RemoveUserKeys < ActiveRecord::Migration
  def up
    drop_table :user_keys
  end

  def down
  end
end
