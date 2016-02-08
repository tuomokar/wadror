class Beer < ActiveRecord::Base
  # module to count average ratings
  include RatingAverage

  validates :name, presence: true
  validates :style, presence: true

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user



  def to_s
    "#{self.name}, by #{self.brewery.name}"
  end
end
