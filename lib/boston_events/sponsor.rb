class BostonEvents::Sponsor < ActiveRecord::Base
    has_many :events
    has_many :categories, through: :events
    has_many :venues, through: :events
  end
  