class BostonEvents::Venue < ActiveRecord::Base
  has_many :events
  has_many :categories, through: :events
  has_many :sponsors, through: :events
end
