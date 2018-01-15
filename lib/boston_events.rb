require_relative '../config/environment'

ActiveRecord::Migration.check_pending!

module BostonEvents
end

require "boston_events/version"
require "boston_events/cli"
require "boston_events/event"
require "boston_events/venue"
require "boston_events/category"
require "boston_events/sponsor"
require "boston_events/scraper"