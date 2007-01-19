class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.column :user_id, :integer
      t.column :type, :string
      t.column :ip_address, :string
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :events
  end
end
