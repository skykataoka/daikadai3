class AddOmniauthColumnsToUsers < ActiveRecord::Migration
  def change
    add_index :users, [:snsid, :snstype], unique: true
  end
end
