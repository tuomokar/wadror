class Membership < ActiveRecord::Base
  belongs_to :beer_club
  belongs_to :user

  validate :beer_club_exists

  def beer_club_exists
    if (BeerClub.all.find_by_id beer_club_id).nil?
      errors.add(:beer_club_id, "must exist")
    end
  end
end
