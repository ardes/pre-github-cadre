class AddActivationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :activation_id, :integer
  end

  def self.down
    remove_column :users, :activation_id
  end
end
