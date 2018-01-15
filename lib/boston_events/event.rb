class BostonEvents::Event < ActiveRecord::Base
  belongs_to :category
  belongs_to :venue
  belongs_to :sponsor
end
