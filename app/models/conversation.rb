class Conversation < ActiveRecord::Base
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User', dependent: :destroy
  belongs_to :receiver, foreign_key: :receiver_id, class_name: 'User', dependent: :destroy

  has_many :messages, dependent: :destroy

  validates_uniqueness_of :sender_id, scope: :receiver_id
  scope :between, -> (sender_id,receiver_id) do
    where("(conversations.sender_id = ? AND conversations.receiver_id =?) OR (conversations.sender_id = ? AND  conversations.receiver_id =?)", sender_id,receiver_id, receiver_id, sender_id)
  end

  def target_user(current_user)
      if sender_id == current_user.id
        User.find(receiver_id)
      elsif receiver_id == current_user.id
        User.find(sender_id)
      end
  end
end
