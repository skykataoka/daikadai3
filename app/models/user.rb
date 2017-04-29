class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable

  mount_uploader :avatar, AvatarUploader #deviseの設定配下に追記
# 省略
   has_many :topics, dependent: :destroy
   has_many :comments, through: :topics, dependent: :destroy

   has_many :relationships, foreign_key: "follower_id", dependent: :destroy
   has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy

   #  Userモデルがrelationshipsモデルを通じて複数のUserを所持することを定義
   has_many :followed_users, through: :relationships, source: :followed
   has_many :followers, through: :reverse_relationships, source: :follower

   has_many :senders, foreign_key: "sender_id", dependent: :destroy, class_name: "Conversation"
   has_many :receivers, foreign_key: "receiver_id", dependent: :destroy, class_name: "Conversation"

   has_many :messages, dependent: :destroy


   def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
      user = User.find_by(email: auth.info.email)

      unless user
        user = User.new(
            name:     auth.extra.raw_info.name,
            snstype: auth.provider,
            snsid:      auth.uid,
            email:    auth.info.email ||= "#{auth.uid}-#{auth.provider}@example.com",
            image_url:   auth.info.image,
            password: Devise.friendly_token[0, 20]
        )
        user.skip_confirmation!
        user.save(validate: false)
      end
      user
    end

    def self.find_for_twitter_oauth(auth, signed_in_resource = nil)
      user = User.find_by(snstype: auth.provider, snsid: auth.uid)

      unless user
        user = User.new(
            name:     auth.info.nickname,
            image_url: auth.info.image,
            snstype: auth.provider,
            snsid:      auth.uid,
            email:    auth.info.email ||= "#{auth.uid}-#{auth.provider}@example.com",
            password: Devise.friendly_token[0, 20]
        )
        user.skip_confirmation!
        user.save
      end
      user
    end

    def self.create_unique_string
      SecureRandom.uuid
    end

    def update_with_password(params, *options)
      if snstype.blank?
        super
      else
        params.delete :current_password
        update_without_password(params, *options)
      end
    end

    #指定のユーザをフォローする
    def follow!(other_user)
      relationships.create!(followed_id: other_user.id)
    end

    #フォローしているかどうかを確認する
    def following?(other_user)
      relationships.find_by(followed_id: other_user.id)
    end

    def unfollow!(other_user)
      relationships.find_by(followed_id: other_user.id).destroy
    end
end
