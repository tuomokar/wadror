class Brewery < ActiveRecord::Base
  # module to count average ratings
  include RatingAverage

  validate :not_in_future
  validates :year, numericality: { greater_than_or_equal_to: 1042,
                                    only_integer: true }
  validates :name, presence: true

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def to_s
    self.name
  end

  def not_in_future
    if year.present? && year > Time.now.year
      errors.add(:year, "can't be in the future")
    end
  end

end
