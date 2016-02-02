class Beer < ActiveRecord::Base
  # module to count average ratings
  include RatingAverage

  validates :name, presence: true

  belongs_to :brewery
  has_many :ratings, dependent: :destroy



  def to_s
    "#{self.name}, by #{self.brewery.name}"
  end
end
