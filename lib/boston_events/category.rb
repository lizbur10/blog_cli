class BostonEvents::Category < ActiveRecord::Base
  has_many :events
  has_many :venues, through: :events
  has_many :sponsors, through: :events
end
