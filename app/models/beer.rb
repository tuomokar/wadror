class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings

  def average_rating
    sum = 0
    self.ratings.each { |rating| sum += rating.score}
    average = sum / (self.ratings.count == 0 ? 1 : self.ratings.count)
  end
end
