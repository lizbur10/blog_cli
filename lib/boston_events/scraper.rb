class BostonEvents::Scraper
    attr_accessor :doc
  
  
    EVENT_SELECTORS = {
      "top-ten" => {
        url: "http://calendar.artsboston.org/",
        iterate_over: "section.list-blog article.blog-itm",
        name: "h2.blog-ttl",
        dates: "div.left-event-time.evt-date-bubble",
        sponsor_and_venue_names: "p.meta",
        event_urls: "div.b-btn.__inline_block_fix_space a"
      },
      "featured" => {
        url: "http://calendar.artsboston.org/categories/",
        iterate_over: "article.category-detail",
        name: "h1.p-ttl",
        dates: "div.left-event-time.evt-date-bubble",
        sponsor_and_venue_names: "p.meta",
        event_urls: "div.b-btn.cat-detail.__inline_block_fix_space a"
      },
      "listed" => {
        url: "http://calendar.artsboston.org/categories/",
        iterate_over: "section.list-category article.category-itm",
        name: "h2.category-ttl",
        dates: "div.left-event-time.evt-date-bubble",
        sponsor_and_venue_names: "p.meta",
        event_urls: "div.b-btn.category a"
      }
    }
  
    def scrape_categories
      doc = Nokogiri::HTML(open("http://calendar.artsboston.org/"))
      doc.search(".main-menu .mn-menu .nav > li > a").each do | link |
        url = link.attribute("href").text.gsub("/categories/","").gsub("/","")
        if !BostonEvents::Category.all.find_by(:url => url)
            new_category = BostonEvents::Category.new
            new_category.url = url
            new_category.name = link.text.strip
            new_category.save
            # puts new_category
        end
      end
      top_ten = BostonEvents::Category.new
      top_ten.url = 'top-ten'
      top_ten.name = 'Top Ten'
      top_ten.save
    end
  
    def route_event_scrape(category)
      if category.url == 'top-ten'
        @doc = Nokogiri::HTML(open(EVENT_SELECTORS['top-ten'][:url]))
        scrape_events(category, 'top-ten')
      else
        @doc = Nokogiri::HTML(open(EVENT_SELECTORS['featured'][:url] + "#{category.url}/"))
        scrape_events(category, 'featured')
        scrape_events(category, 'listed')
      end # if/else
    end
  
    def scrape_events(category, type)
        @doc.search(EVENT_SELECTORS[type][:iterate_over]).each_with_index do | this_event, index |
            event = BostonEvents::Event.new
            event.name = this_event.search(EVENT_SELECTORS[type][:name]).text.strip
    
            dates = this_event.search(EVENT_SELECTORS[type][:dates])
            event.dates = get_event_dates(dates)
    
            sponsor_name = this_event.search(EVENT_SELECTORS[type][:sponsor_and_venue_names])[0].text.strip.gsub("Presented by ","").gsub(/  at .*/,"")
            event.sponsor = BostonEvents::Sponsor.find_or_create_by(:name => sponsor_name)
    
            venue_name = this_event.search(EVENT_SELECTORS[type][:sponsor_and_venue_names])[0].text.split(" at ")[1].strip
            event.venue = BostonEvents::Venue.find_or_create_by(:name => venue_name)
    
            event.deal_url = this_event.search(EVENT_SELECTORS[type][:event_urls])[1].attribute("href") if this_event.search(EVENT_SELECTORS[type][:event_urls])[1]
            event.website_url = this_event.search(EVENT_SELECTORS[type][:event_urls])[0].attribute("href") if this_event.search(EVENT_SELECTORS[type][:event_urls])[0]
    
            event.category = category
            event.save
            ## Using this binding shows that category.events always returns an empty array but venue.events or sponsor.events returns an array of events
            # binding.pry
        end
    end
  
    def get_event_dates(dates)
      if dates.search("div.date").length > 0
        dates.search("div.month").text.gsub(/\s+/," ").strip + " - " + dates.search("div.date").text.gsub(/\s+/," ").strip
      else
        dates.search("div.month").text.gsub(/\s+/," ").strip
      end
    end
  
  end
  