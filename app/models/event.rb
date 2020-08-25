class Event < ApplicationRecord
  belongs_to :user
  has_many :queue_estimations
  has_one :chatroom
end
