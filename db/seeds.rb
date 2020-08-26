Event.destroy_all

scrape = Scraper.new
events = scrape.scrape_event_urls
Event.create_from_scraping(events)



