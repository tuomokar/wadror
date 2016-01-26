class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings

  def average_rating
    self.ratings.count == 0 ? 0 : self.ratings.average(:score).round(2)
  end
end
