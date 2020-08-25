class QueueEstimation < ApplicationRecord
  belongs_to :event
  belongs_to :user
  validates :waiting_time, presence: true
end
