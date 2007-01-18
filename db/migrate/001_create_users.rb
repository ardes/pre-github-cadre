class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :email, :string
      t.column :password_algorithm, :string, :null => false
      t.column :password_hash, :string, :null => false
      t.column :password_salt, :string, :null => false
      t.column :display_name, :string
    end
  end

  def self.down
    drop_table :users
  end
end
