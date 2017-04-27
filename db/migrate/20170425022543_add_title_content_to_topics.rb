class AddTitleContentToTopics < ActiveRecord::Migration
  def change
    add_reference :topics, :user, foreign_key: true
    add_column :topics, :title, :string
    add_column :topics, :content, :text
  end
end
