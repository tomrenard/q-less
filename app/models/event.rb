class Event < ApplicationRecord
  belongs_to :user

  has_many :queue_estimations, dependent: :destroy
  has_one :chatroom, dependent: :destroy
  has_one_attached :photo

end
