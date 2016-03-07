class Rating < ActiveRecord::Base
  belongs_to :beer, touch: true
  belongs_to :user

  has_one :brewery, through: :beer

  validates :score, numericality: { greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 50,
                                    only_integer: true }

  scope :last_five, -> { order(created_at: :desc).limit(5) }

  def to_s
    "#{self.beer.name}, score: #{self.score}"
  end
end
