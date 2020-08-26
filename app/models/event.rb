class Event < ApplicationRecord
  belongs_to :user
  has_many :queue_estimations, dependent: :destroy
  has_one :chatroom, dependent: :destroy
  has_one_attached :photo
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
