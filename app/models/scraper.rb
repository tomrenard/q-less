require 'date'
require 'nokogiri'
require 'open-uri'
require 'selenium-webdriver'
require 'watir'

class Scraper
  def scrape_location
    locs = []
    browser = Watir::Browser.new :chrome
    url = 'https://ra.co/sitemap'
    browser.goto(url)
    html = (open(browser.url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE, 'User-Agent' => 'opera'))
    doc = Nokogiri::HTML(html)
    lks = doc.css('.Link__AnchorWrapper-k7o46r-1.nrxMV')
    lks.each do |lk|
      url = lk.attribute('href').value
      locs << url if url.include?('events/de/berlin')
    end
    p locs
    browser.close
    generate_url(locs)
  end

  def generate_url(locs)
    urls = []
    locs.each do |loc|
      date = Date.today
      dates = [date]
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
      html = (open(browser.url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE, 'User-Agent' => 'opera'))
      doc = Nokogiri::HTML(html)
      links = doc.css('.Box-omzyfs-0.gExFDv').search('a')
      links.each do |link|
        url = link.attribute('href').value
        events_urls << url if url.include?('event') && url.exclude?('tickets')
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
      title = doc.css('.Text-sc-1t0gn2o-0.llxwqv').text.gsub("\n", '').gsub("\r", '')
      title2 = doc.css('.Text-sc-1t0gn2o-0.lYqGv').text.gsub("\n", '').gsub("\r", '')
      location_data = doc.css('.Text-sc-1t0gn2o-0.Link__StyledLink-k7o46r-0.hpyRNz').first.text
      location2 = doc.css('.Text-sc-1t0gn2o-0.cvGKBC').text
      reg_digit = /\d/
      location_data.match(reg_digit) ? location = location2 : location = location_data
      ad = doc.css('.Grid__GridStyled-sc-1l00ugd-0.itbbwg.grid').css('.Text-sc-1t0gn2o-0.dhoduX').text
      start_date = doc.css('.Text-sc-1t0gn2o-0.Link__StyledLink-k7o46r-0.hpyRNz')[1] || doc.css('.Text-sc-1t0gn2o-0.Link__StyledLink-k7o46r-0.hpyRNz').first
      # start_h = doc.css('.Text-sc-1t0gn2o-0.dhoduX').slice(1).text
      # end_h = doc.css('.Text-sc-1t0gn2o-0.dhoduX').slice(3).text
      line_up = doc.css('[data-tracking-id=event-detail-lineup]').text.gsub('Lineup', '')
      # prom = doc.css('.Text-sc-1t0gn2o-0.dhoduX').slice(4).text.gsub("\n", '').gsub("\r", '')
      # age = doc.css('.Box-omzyfs-0.kXpspU>span').text.include?('ageD')
      # age ? 'You better take 15 bucks, just in case' : price = doc.css('.Text-sc-1t0gn2o-0.dhoduX').last.text # warning
      des = doc.css('.Text-sc-1t0gn2o-0.EventDescription__BreakText-a2vzlh-0.kcYnvu').text.gsub("\n", '').gsub("\r", '')
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
        location: location || 'Unknown location',
        address: ad.empty? || ad.nil? ? 'Hmmm good luck, you should guess' : ad,
        start_time: start_date.text,
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
     events
  end
end
