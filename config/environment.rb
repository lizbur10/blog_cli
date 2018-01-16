require 'active_record'
require 'pry'
require 'nokogiri'
require 'open-uri'



ActiveRecord::Base.establish_connection({
  :adapter => "sqlite3",
  :database => "db/boston_events.sqlite"
})
