class CreateUserProperties < ActiveRecord::Migration
  def self.up
    create_table :user_properties do |t|
      t.column :password_algorithm, :string
    end
  end

  def self.down
    drop_table :user_properties
  end
end
