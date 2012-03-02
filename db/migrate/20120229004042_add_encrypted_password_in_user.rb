class AddEncryptedPasswordInUser < ActiveRecord::Migration
  def up
    add_column :users, :encrypted_password, :string
  end

  def down
    remove_column :users, :encrpyted_password
  end
end
