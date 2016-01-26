class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings

  # if there are no ratings, returns zero, otherwise returns average of scores of ratings
  def average_rating
    self.ratings.count == 0 ? 0 : self.ratings.average(:score).round(2)
  end

  def to_s
    "#{self.name}, by #{self.brewery.name}"
  end
end
