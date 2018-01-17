class BostonEvents::CLI
  attr_reader :last_input

  def call
    puts; puts
    puts "Hi! Welcome to the Boston Events Finder!"
    puts "You can quit this app at any time by typing exit."
    puts; puts "Categories loading..."
    @last_input = nil
    scraper = BostonEvents::Scraper.new
    while @last_input != "exit"
      select_category(scraper)
    end #while
  end

  def select_category(scraper)
    # scraper.categories == nil ? scraper.scrape_categories : scraper.categories
    BostonEvents::Category.all.size == 0 ? scraper.scrape_categories : nil
    puts; puts "Start by selecting a category:"
    BostonEvents::Category.all.each.with_index(1) do | category, index |
      puts "#{index}. #{category.name}"
    end
    user_input
    if @last_input.to_i > 0 && @last_input.to_i <= BostonEvents::Category.all.length
      category = BostonEvents::Category.all.detect.with_index(1) { | category, index | @last_input.to_i == index }
    elsif @last_input == "exit"
      exit_app
    else
      puts "I'm not sure what you want - please enter a category number or type exit"
      select_category(scraper)
    end # if/elsif/else
    BostonEvents::Event.list_events(scraper, category)
    list_events_in_category(scraper, category)
end # #select_category

  def list_events_in_category(scraper, category)
    puts; puts "Here's what's happening in the #{category.name.capitalize} category:"
    puts

######### This line works without the 'all' if the events pre-existed in the db but NOT if they are scraped at the time the app is run
    category.events.all.each.with_index(1) do | event, index | 
      puts "#{index}. #{event.name}, #{event.dates}, presented by #{event.sponsor.name}"
    end #each
    puts; puts "Select an event to see more information or type 'list' to return to the category list."
    choose_event_to_view(scraper, category)
  end # #list_events_in_category

  def choose_event_to_view(scraper, category)
    while user_input != 'exit'
      if @last_input.to_i >= 1 && @last_input.to_i <= category.events.all.length   ############# Here too
        event = BostonEvents::Event.all.detect.with_index(1) { | event, index | @last_input.to_i == index }
        return_event_info(category, @last_input)
      elsif @last_input == "list"
        select_category(scraper)
      # elsif @last_input == "exit"
      #   exit_app
      else
        puts "I'm not sure what you want - please enter a number between 1 and #{category.events.length} or type list."
      end # if/elsif/else
    end
    @last_input == "exit" ? exit_app : nil 
  end

  def return_event_info(category, input)
    category.events.all.detect.with_index(1) do | event, index |  ############ And here
      if input.to_i == index
        puts_event_info(event)
      end
    end # detect
    puts; puts "Select another event or type 'list' to return to the category list."
  end

  def puts_event_info(event)
    puts; puts "OK, here are the details:"
    puts; puts "#{event.name}"
    puts "Date(s): #{event.dates}"
    puts "Presented by #{event.sponsor.name}"
    puts "Venue: #{event.venue.name}"
    puts "Event website: #{event.website_url}" if event.website_url
    puts "Check Here for Deals: #{event.deal_url}" if event.deal_url
  end

  private

    def user_input
      @last_input = gets.strip.downcase
    end

    def clear_db
      BostonEvents::Event.destroy_all
      BostonEvents::Category.destroy_all
      BostonEvents::Venue.destroy_all
      BostonEvents::Sponsor.destroy_all

    end

    def exit_app
      clear_db
      abort ("\nThanks for stopping by -- come back often to check out what's going on around town!")
    end

    def open_in_browser(url)
      system("open '#{url}'")
    end

  end
