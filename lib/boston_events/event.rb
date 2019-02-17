class BostonEvents::Event < ActiveRecord::Base
  belongs_to :category
  belongs_to :venue
  belongs_to :sponsor

  def self.list_events(scraper, category)
    if category.events.length == 0
      puts; puts "Retrieving events..."
      puts
      scraper.route_event_scrape(category)
    end
  end

end
