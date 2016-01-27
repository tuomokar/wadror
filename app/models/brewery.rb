class Brewery < ActiveRecord::Base
  # module to count average ratings
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def to_s
    self.name
  end

end
