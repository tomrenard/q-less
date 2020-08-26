require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper
  def scrape_event_urls
    # date = Date.new
    berlin_url = 'https://www.residentadvisor.net/events/de/berlin/month/2020-08-26'
    html = open(berlin_url)
    doc = Nokogiri::HTML(html)
    events = doc.css('div.bbox').css('.event-title>a')
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

      name = doc.css('#sectionHead h1').text
      location = doc.css('#detail').css('.wide').css('.cat-rev').text
      price = doc.css('#detail').css('li')[2].text
      line_up = doc.css('.lineup').text
      description = doc.css('.left p').text
      # opening_hours =

      img_urls = []

      img_links = doc.css('.flyer a')
      img_links.each do |img_link|
        img_url = img_link.attribute('href').value
        img_urls << img_url
      end

      event_info = {
        name: name,
        location: location,
        price: price,
        line_up: line_up,
        descript: description,
        img: img_urls[0]
      }

      p event_info
    end
    p events_list
  end
end

scrape = Scraper.new
scrape.scrape_event_urls
