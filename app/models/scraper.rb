require 'nokogiri'
require 'open-uri'
require 'pry'
require 'resolv-replace'
require 'date'

class Scraper
  def scrape_event_urls
    date = Date.today
    urls_array = []
    berlin_url = "https://www.residentadvisor.net/events/de/berlin/week/#{date}"
    paris_url = "https://www.residentadvisor.net/events/fr/paris/week/#{date}"
    london_url = "https://www.residentadvisor.net/events/uk/london/week/#{date}"
    uk_north_url = "https://www.residentadvisor.net/events/uk/north/week/#{date}"
    fr_west_url = "https://www.residentadvisor.net/events/fr/west/week/#{date}"
    fr_southeast_url = "https://www.residentadvisor.net/events/fr/southeast/week/#{date}"
    fr_southwest_url = "https://www.residentadvisor.net/events/fr/southwest/week/#{date}"
    fr_north_url = "https://www.residentadvisor.net/events/fr/north/week/#{date}"
    fr_east_url = "https://www.residentadvisor.net/events/fr/east/week/#{date}"
    fr_central_url = "https://www.residentadvisor.net/events/fr/central/week/#{date}"
    fr_frenchriviera_url = "https://www.residentadvisor.net/events/fr/frenchriviera/week/#{date}"
    es_barcelona_url = "https://www.residentadvisor.net/events/es/barcelona/week/#{date}"
    es_madrid_url = "https://www.residentadvisor.net/events/es/madrid/week/#{date}"
    es_ibiza_url = "https://www.residentadvisor.net/events/es/ibiza/week/#{date}"
    it_north_url = "https://www.residentadvisor.net/events/it/north/week/#{date}"
    nl_amsterdam_url = "https://www.residentadvisor.net/events/nl/amsterdam/week/#{date}"
    urls_array << berlin_url
    urls_array << paris_url
    urls_array << fr_west_url
    urls_array << fr_southeast_url
    urls_array << fr_southwest_url
    urls_array << fr_north_url
    urls_array << fr_east_url
    urls_array << fr_central_url
    urls_array << fr_frenchriviera_url
    urls_array << london_url
    urls_array << uk_north_url
    urls_array << es_barcelona_url
    urls_array << es_madrid_url
    urls_array << es_ibiza_url
    urls_array << it_north_url
    urls_array << nl_amsterdam_url
    event_urls = []
    urls_array.each do |url_array|
      html = open(url_array)
      doc = Nokogiri::HTML(html)
      events = doc.css('div.bbox').css('.event-title>a')
      events.each do |event|
        url = event.attribute('href').value
        event_urls << url
      end
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
      regexp_2020 = /^(.*?2020)/
      regexp_2021 = /^(.*?2021)/
      info_date = doc.css('#detail').css('li a').text
      starting_date = info_date.match(regexp_2020) || info_date.match(regexp_2021)

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
      event_info[:address] = address[1].lstrip unless address.nil?
      # || address[0].include?("Secret") || address[0].exclude?("Berlin")
      event_info[:start_time] = starting_date[1] unless starting_date.nil?
      event_info[:start_time] = Date.parse(event_info[:start_time]).strftime('%Y-%m-%d')
      event_info[:user] = User.first

      if img_urls[0].nil?
        event_info[:photo_link] = "https://source.unsplash.com/featured/?nightclub"
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
    p events_list
  end
end

