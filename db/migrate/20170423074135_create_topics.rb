class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.references :user ,foreign_key: true
      t.string :title
      t.text :content
      t.timestamps null: false
    end
  end
end
