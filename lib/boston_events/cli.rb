class BostonEvents::CLI
  attr_reader :last_input

  def call
    puts; puts
    puts "Hi! Welcome to the Boston Events Finder!"
    # puts "You can quit this app at any time by typing exit."
    puts; puts "Categories loading..."
    @last_input = nil
    scraper = BostonEvents::Scraper.new
    while @last_input != "exit" && @last_input != 'x'
      select_category(scraper)
    end #while
  end

  def select_category(scraper)
    # scraper.categories == nil ? scraper.scrape_categories : scraper.categories
    scraper.scrape_categories
    puts; puts "Start by selecting a category:"
    BostonEvents::Category.all.each.with_index(1) do | category, index |
      puts "#{index}. #{category.name}"
    end
    puts; puts "ENTER:"
    puts "   a category number to see the events in that category"
    puts "   'exit' or 'x' to quit the app"
    puts    
    user_input
    check_input(scraper)
    if @last_input.to_i > 0 && @last_input.to_i <= BostonEvents::Category.all.length
      BostonEvents::Event.list_events(scraper, get_category)
      list_events_in_category(scraper, get_category)

      # elsif @last_input == "exit" || @last_input == "x"
    #   exit_app
    else
      puts "I'm not sure what you want - please enter a category number or type exit"
      select_category(scraper)
    end # if/elsif/else
    # category = get_category
end # #select_category

  def list_events_in_category(scraper, category)
    category.events.each.with_index(1) do | event, index | 
      puts "#{index}. #{event.name}, #{event.dates}, presented by #{event.sponsor.name}"
    end #each
    puts; puts "ENTER:"
    puts "   an event number to see the details for that event"
    puts "   'cats' or 'c' to return to the category list"
    puts "   'exit' or 'x' to quit the app"
    puts
    user_input
    check_input(scraper, category)
    choose_event_to_view(scraper, category)
  end # #list_events_in_category

  def choose_event_to_view(scraper, category)
    # while user_input != 'exit' && user_input != 'x'
    if @last_input.to_i >= 1 && @last_input.to_i <= category.events.length
        event = get_event
        scraper.scrape_event_description(event)
        # !!! EVENT DETAIL SCRAPER CALLED HERE !!! #
        
        return_event_info(scraper, category, get_event)
      # elsif @last_input == "cats" || @last_input == 'c'
      #   select_category(scraper)
      # elsif @last_input == 'events' || @last_input == 'v'
      #   list_events_in_category(scraper, category)
    else
        puts "I'm not sure what you want - please enter a number between 1 and #{category.events.length} or type list."
        choose_event_to_view(scraper, category)
      end # if/elsif/else
    # @last_input == "exit" || @last_input == 'x' ? exit_app : nil 
  end

  def return_event_info(scraper, category, event)
        puts_event_info(event)
    
    puts; puts "ENTER:"
    puts "   'events' or 'v' to see the list of events in the #{category.name.upcase} category"
    puts "   'cats' or 'c' to return to the category list"
    puts "   'exit' or 'x' to quit the app"
    puts    
    user_input
    check_input(scraper, category)
  end

  def puts_event_info(event)
    puts "\e[2J\e[0;0H" # http://ruby.11.x6.nabble.com/Is-there-a-way-to-clear-the-contents-of-a-terminal-td2988827.html
    puts; puts "======================================================================================="
    puts; puts "OK, here are the details:"
    puts; puts "#{event.name.upcase}"
    puts; puts "DATE(s): #{event.dates}"
    puts "Presented by #{event.sponsor.name}"
    puts "Venue: #{event.venue.name}"
    puts "Event website: #{event.website_url}" if event.website_url
    puts "Check Here for Deals: #{event.deal_url}" if event.deal_url
    puts; puts event.description
    puts; puts "======================================================================================="

  end

  private

    def user_input
      @last_input = gets.strip.downcase
    end

    def check_input(scraper, category=nil)
      if @last_input == "exit" || @last_input == "x"
        exit_app
      elsif @last_input == "cats" || @last_input == "c"
        select_category(scraper)
      elsif @last_input == "events" || @last_input == "v"
        list_events_in_category(scraper, category) if !!category
      end
    end

    def clear_db
      BostonEvents::Event.destroy_all
      BostonEvents::Category.destroy_all
      BostonEvents::Venue.destroy_all
      BostonEvents::Sponsor.destroy_all
    end

    def get_category
      BostonEvents::Category.all.detect.with_index(1) { | category, index | @last_input.to_i == index }
    end

    def get_event
      BostonEvents::Event.all.detect.with_index(1) { | event, index | @last_input.to_i == index }
    end

    def exit_app
      clear_db
      abort ("\nThanks for stopping by -- come back often to check out what's going on around town!")
    end

  end
