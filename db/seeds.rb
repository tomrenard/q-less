Event.destroy_all

scrape = Scraper.new()
events = scrape.scrape_location
Event.create_from_scraping(events)



