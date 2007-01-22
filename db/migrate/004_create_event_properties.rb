class CreateEventProperties < ActiveRecord::Migration
  def self.up
    create_table :event_properties do |t|
      t.column :key_algorithm, :string
    end
  end

  def self.down
    drop_table :event_properties
  end
end
