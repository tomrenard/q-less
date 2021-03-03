Event.destroy_all

scrape = Scraper.new
events_l = scrape.scrape_location
Event.create_from_scraping(events_l)



