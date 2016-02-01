class Rating < ActiveRecord::Base
  belongs_to :beer
  belongs_to :user

  def to_s
    "#{self.beer.name}, score: #{self.score}"
  end
end
