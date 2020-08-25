require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  def scrape_event
    output = {}

    berlin_events_url = 'https://www.residentadvisor.net/events/de/berlin/month/2020-08-25'
    html = open(berlin_events_url)
    doc = Nokogiri::HTML(html)
    events = doc.css('div.bbox')

    events.each do |event|
      event_name = event.css('.event-title a').text
      event_location = event.css('event-title span a').text

      p output = {
        :event_name => event_name,
        :event_location => event_location
      }
    end
  end
end

scrape = Scraper.new
scrape.scrape_event
