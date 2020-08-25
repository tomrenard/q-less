class Event < ApplicationRecord
  belongs_to :user
  has_many :queue_estimations
  has_one :chatroom
  has_one_attached :photo
  validates :title, presence: true
  validates :description, presence: true
  validates :category, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :address, presence: true
  validates :price, presence: true
  validates :line_up, presence: true
  validates :location, presence: true
end
