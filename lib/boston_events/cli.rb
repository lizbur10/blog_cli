class BostonEvents::CLI
  attr_reader :last_input

  def call
    puts; puts
    puts "Hi! Welcome to the Boston Events Finder -- your BEF friend in the Boston area!"
    puts "You can quit this app at any time by typing exit."
    puts; puts "Categories loading..."
    @last_input = nil
    scraper = BostonEvents::Scraper.new
    while @user_input != "exit"
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
      binding.pry
    elsif @last_input == "exit"
      BostonEvents::Event.destroy_all
      BostonEvents::Category.destroy_all
      BostonEvents::Venue.destroy_all
      BostonEvents::Sponsor.destroy_all
      abort ("\nThanks for stopping by -- come back often to check out what's going on around town!")
    else
      puts "I'm not sure what you want - please enter a category number or type exit"
      select_category(scraper)
    end # if/elsif/else
    binding.pry
    BostonEvents::Event.list_events(scraper, category)
    binding.pry
    list_events_in_category(scraper, category)
end # #select_category

  def list_events_in_category(scraper, category)
    puts; puts "Here's what's happening in the #{category.name.capitalize} category:"
    puts
    binding.pry
    category.events.each.with_index(1) do | event, index |
      puts "#{index}. #{event.name}, #{event.dates}, presented by #{event.sponsor.name}"
    end #each
    puts; puts "Select an event to see more information or type 'list' to return to the category list."
    choose_event_to_view(scraper, category)
  end # #list_events_in_category

  def choose_event_to_view(scraper, category)
    while user_input != 'exit'
      if @last_input.to_i >= 1 && @last_input.to_i <= category.events.length
        event = BostonEvents::Event.all.detect.with_index(1) { | event, index | @last_input.to_i == index }
        return_event_info(category, input)
      elsif @last_input == "list"
        select_category(scraper)
      elsif @last_input == "exit"
        abort ("\nThanks for stopping by -- come back often to check out what's going on around town!")
      else
        puts "I'm not sure what you want - please enter a number between 1 and #{category.events.length} or type list."
      end # if/elsif/else
    end
  end


  private

    def user_input
      @last_input = gets.strip.downcase
    end

end
