module UsersHelper

  def get_membership(user, beer_club)
    Membership.find_by(user_id: user.id, beer_club_id: beer_club.id)
  end
end
