class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
# 省略
   has_many :topics, dependent: :destroy
   has_many :comments, dependent: :destroy

   has_many :relationships, foreign_key: "follower_id", dependent: :destroy
   has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy

   #  Userモデルがrelationshipsモデルを通じて複数のUserを所持することを定義
   has_many :followed_users, through: :relationships, source: :followed
   has_many :followers, through: :reverse_relationships, source: :follower

   has_many :senders, foreign_key: "sender_id", dependent: :destroy, class_name: "Conversation"
   has_many :receivers, foreign_key: "receiver_id", dependent: :destroy, class_name: "Conversation"

   has_many :messages, dependent: :destroy
end
