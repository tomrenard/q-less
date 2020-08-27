class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  acts_as_tagger
  has_many :events
  has_many :received_follows, foreign_key: :followed_user_id, class_name: "Follow"
  has_many :followers, through: :received_follows, source: :follower
  has_many :given_follows, foreign_key: :follower_id, class_name: "Follow"
  has_many :followings, through: :given_follows, source: :followed_user
  has_many :event_wishlists
end
