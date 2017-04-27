class EditColumnToUser < ActiveRecord::Migration
  def change
    remove_index :users, [:snsid, :snstype]
  end
end
