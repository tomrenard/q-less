require 'nokogiri'
require 'open-uri'
require 'pry'
require 'resolv-replace'
require 'date'

class Scraper
  def scrape_event_urls
    date = Date.today
    berlin_url = "https://www.residentadvisor.net/events/de/berlin/week/#{date}"
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
      title = doc.css('#sectionHead h1').text
      location = doc.css('#detail').css('.wide').css('.cat-rev').text.gsub("\n", "")

      regexp_d = /^(.*?2020)/
      info_date = doc.css('#detail').css('li a').text
      starting_date = info_date.match(regexp_d)

      line_up = doc.css('.lineup').text.gsub("\n", "")
      description = doc.css('.left').css('p')[1].text.gsub("\n", "")

      regexp_a = /.*<br>(.*)<br>.*/
      address_html = doc.search('#detail').search('li.wide').inner_html
      address = address_html.match(regexp_a)

      img_urls = []
      img_links = doc.css('.flyer a')
      img_links.each do |img_link|
        img_url = img_link.attribute('href').value
        img_urls << "https://www.residentadvisor.net#{img_url}"
      end

      event_info = {
        location: location,
        line_up: line_up,
        description: description
      }
      event_info[:address] = address[1].lstrip unless address.nil? || address[0].include?("Secret") || address[0].exclude?("Berlin")
      event_info[:start_time] = starting_date[1] unless starting_date.nil?
      event_info[:start_time] = Date.parse(event_info[:start_time]).strftime('%Y-%m-%d')
      event_info[:user] = User.first

      if img_urls[0].nil?
        event_info[:photo_link] = "https://source.unsplash.com/featured/?club"
      else
        event_info[:photo_link] = img_urls[0]
      end

      if event_info[:location] == "Sage Beach Berlin"
        event_info[:title] = location
      else
        event_info[:title] = title
      end

      events_list << event_info
    end
    events_list
  end
end
