class Brewery < ActiveRecord::Base
  include RatingAverage

  validate :not_in_future
  validates :year, numericality: { greater_than_or_equal_to: 1042,
                                    only_integer: true }
  validates :name, presence: true

  scope :active, -> { where active:true }
  scope :retired, -> { where active:[nil,false] }

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def to_s
    self.name
  end

  def self.top
    sorted_rating_in_desc_order = Brewery.all.sort_by{ |b| -(b.average_rating||0)}
    sorted_rating_in_desc_order.take(3)
  end

  def not_in_future
    if year.present? && year > Time.now.year
      errors.add(:year, "can't be in the future")
    end
  end

end
