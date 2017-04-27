class Conversation < ActiveRecord::Base
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User', dependent: :destroy
  belongs_to :receiver, foreign_key: :receiver_id, class_name: 'User', dependent: :destroy

  has_many :messages, dependent: :destroy
end
