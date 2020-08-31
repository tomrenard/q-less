class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  acts_as_tagger
  has_many :events
  has_many :event_wishlists
  has_many :active_follows, class_name: "Follow", foreign_key: :follower_id, dependent: :destroy
  has_many :passive_follows, class_name: "Follow", foreign_key: :followed_user_id, dependent: :destroy
  has_many :followings, through: :active_follows, source: :followed_user
  has_many :followers, through: :passive_follows, source: :follower

  def follow(user)
    active_follows.create(followed_user_id: user.id)
  end

  def unfollow(user)
    active_follows.find_by(followed_user_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  def find_follow(user)
    active_follows.find_by(followed_user_id: user.id)
  end
end
