# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 2) do

  create_table "user_properties", :force => true do |t|
    t.column "password_algorithm", :string
  end

  create_table "users", :force => true do |t|
    t.column "email",              :string
    t.column "password_algorithm", :string, :default => "", :null => false
    t.column "password_hash",      :string, :default => "", :null => false
    t.column "password_salt",      :string, :default => "", :null => false
    t.column "display_name",       :string
  end

end
