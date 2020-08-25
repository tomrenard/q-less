require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  def scrape_event_urls
    berlin_url = 'https://www.residentadvisor.net/events/de/berlin/month/2020-08-25'
    html = open(berlin_url)
    doc = Nokogiri::HTML(html)
    events = doc.css('div.bbox').css('.event-title').css('a')
    event_urls = []

    events.each do |event|
      url = event.attribute('href').value
      event_urls << url
    end

    scrape_event_pages(event_urls)
  end

  def scrape_event_pages(event_urls)
    events_list = []
    event_urls.each do |event_url|
      url = "https://www.residentadvisor.net#{event_url}"
      html = open(url)
      doc = Nokogiri::HTML(html)

      name = doc.css('#sectionHead').css('.add-space h1').text
      # location = doc.css('div.plus8').css('.cat-rev > a').text
      # location =
      # address =
      # img_link =


      events_list << name
      # events_list << location
       # address, location, address, img_link
      p events_list
    end
  end

  # def create_events(events_list)
  #   events_list.each do |event|
  #     name = event.css()
  #     location = event.css

  # end

end

scrape = Scraper.new
p scrape.scrape_event_urls
