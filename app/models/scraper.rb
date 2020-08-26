require 'nokogiri'
require 'open-uri'
require 'pry'
require 'resolv-replace'

class Scraper
  def scrape_event_urls
    date = Date.today
    berlin_url = "https://www.residentadvisor.net/events/de/berlin/month/#{date}"
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

      # starting_date = doc.css('#detail').css('li a').inner_html

      # regexp_p = /\d+/
      # price_text = doc.css('#detail').css('li')[2].text
      # pr = price_text.match(regexp_p)
      # price = pr[1].to_i unless pr.nil?

      line_up = doc.css('.lineup').text.gsub("\n", "")
      description = doc.css('.left').css('p')[1].text.gsub("\n", "")

      # opening_hours = doc.css('#detail').css('li')[0].text

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
        title: title,
        location: location,
        line_up: line_up,
        description: description
        # photo: img_urls[0]
        # starting_date: starting_date
      }
      event_info[:address] = address[1].lstrip unless address.nil?

      events_list << event_info
    end
    events_list
  end
end

scrape = Scraper.new
events = scrape.scrape_event_urls
