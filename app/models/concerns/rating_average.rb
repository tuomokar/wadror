module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    self.ratings.count == 0 ? 0 : self.ratings.average(:score).round(1)
  end
end