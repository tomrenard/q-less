require 'date'
require 'nokogiri'
require 'open-uri'
require 'watir'
require 'webdrivers'
require 'selenium-webdriver'

class Scraper
  def scrape_location
    locs = []
    browser = Watir::Browser.new
    url = 'https://ra.co/sitemap'
    browser.goto(url)
    html = (open(b.url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE, 'User-Agent' => 'opera'))
    doc = Nokogiri::HTML(html)
    lks = doc.css('.Link__AnchorWrapper-k7o46r-1.cBCLIt')
    lks.each do |lk|
      url = lk.attribute('href').value
      locs << url if url.include?('events/de/berlin')
    end
    browser.close
    generate_url(locs)
  end

  def generate_url(locs)
    urls = []
    locs.each do |loc|
      date = Date.today
      dates = [date, date + 7]
      dates.each do |d|
        url = "https://ra.co#{loc}?week=#{d}"
        urls << url
      end
    end
    scrape_event_url(urls)
  end

  def scrape_event_url(urls)
    events_urls = []
    urls.each do |url|
      browser = Watir::Browser.new
      browser.goto(url)
      html = (open(b.url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE, 'User-Agent' => 'opera'))
      doc = Nokogiri::HTML(html)
      links = doc.css('.Box-omzyfs-0.bFNVvf').search('a')
      links.each do |link|
        url = link.attribute('href').value
        events_urls << url if url.include?('event')
      end
      browser.close
    end
    scrape_event_content(events_urls)
  end

  def scrape_event_content(events_urls)
    events = []
    events_urls.each do |events_url|
      url = "https://ra.co/#{events_url}"
      html = (open(url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE, 'User-Agent' => 'opera'))
      doc = Nokogiri::HTML(html)
      title = doc.css('.Text-sc-1t0gn2o-0.lYqGv').text.gsub("\n", '').gsub("\r", '')
      title2 = doc.css('.Text-sc-1t0gn2o-0.llxwqv').text.gsub("\n", '').gsub("\r", '')
      location = doc.css('.Text-sc-1t0gn2o-0.Link__StyledLink-k7o46r-0.hvqKqA').first || 'Unknown location'
      ad = doc.css('.Grid__GridStyled-sc-1l00ugd-0.hTDtOT.grid').css('.Text-sc-1t0gn2o-0.dhoduX')
      start_date = doc.css('.Text-sc-1t0gn2o-0.Link__StyledLink-k7o46r-0.hvqKqA').last.text.gsub("\n", '').gsub("\r", '')
      start_h = doc.css('.Text-sc-1t0gn2o-0.dhoduX').slice(1).text
      end_h = doc.css('.Text-sc-1t0gn2o-0.dhoduX').slice(3).text
      line_up = doc.css('.Text-sc-1t0gn2o-0.CmsContent__StyledText-g7gf78-0').text.gsub("\n", '').gsub("\r", '') # warning
      prom = doc.css('.Text-sc-1t0gn2o-0.dhoduX').slice(4).text.gsub("\n", '').gsub("\r", '')
      age = doc.css('.Box-omzyfs-0.kXpspU>span').text.include?('ageD')
      age ? 'You better take 15 bucks, just in case' : price = doc.css('.Text-sc-1t0gn2o-0.dhoduX').last.text # warning
      des = doc.css('.Text-sc-1t0gn2o-0.EventDescription__BreakText-a2vzlh-0.hPALEa').text.gsub("\n", '').gsub("\r", '')
      img_urls = []
      img_links = doc.css('.FullWidthStyle-sc-4b98ap-0.htnFjY>img')
      img_links.each do |img_link|
        img_url = img_link.attribute('src').value
        img_urls << img_url.to_s
      end
      desc_stg = 'Oups, looks like the description is secret or someone was lazy here...'
      reg_h = /^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/
      event_info = {
        title: title.empty? ? title2 : title,
        location: location.text,
        address: ad.empty? || ad.nil? ? 'Hmmm good luck, you should guess' : ad.first.text.gsub("\r", '').gsub("\n", ''),
        start_time: start_date,
        # start_h: start_h.match(reg_h)[0],
        # end_h: end_h.match(reg_h)[0],
        line_up: line_up,
        # promoter: prom,
        description: des.empty? || des.nil? ? desc_stg : des,
        user: User.first,
        photo_link: img_urls[0] || 'https://source.unsplash.com/featured/?nightclub',
        # price: price.nil? ? 'Take 15 just in case' : price
      }
      events << event_info
    end
    return events
  end
end

