class Style < ActiveRecord::Base
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  def to_s
    name
  end

  def self.top
    sorted_rating_in_desc_order = Style.all.sort_by{ |s| -(s.average_rating||0)}
    sorted_rating_in_desc_order.take(3)
  end
end
