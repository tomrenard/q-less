class Event < ApplicationRecord
  belongs_to :user, optional: true
  has_many :queue_estimations, dependent: :destroy
  has_one :chatroom, dependent: :destroy
  has_one_attached :photo
  acts_as_taggable_on :tags
  acts_as_taggable_on :genre, :size, :place
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  has_many :event_wishlists

  def self.create_from_scraping(events)
    events.each do |event_info|
      Event.create!(event_info)
    end
  end
end
