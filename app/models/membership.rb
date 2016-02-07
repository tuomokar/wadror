class Membership < ActiveRecord::Base
  belongs_to :beer_club
  belongs_to :user

  validates_uniqueness_of :user_id, :scope => [:beer_club_id], message: "is already a member of that club"
  validate :beer_club_exists

  def beer_club_exists
    if (BeerClub.all.find_by_id beer_club_id).nil?
      errors.add(:beer_club_id, "must exist")
    end
  end
end
