class Brewery < ActiveRecord::Base
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def to_s
    self.name
  end

  def average_rating
    self.ratings.count == 0 ? 0 : self.ratings.average(:score).round(2)
  end
end
