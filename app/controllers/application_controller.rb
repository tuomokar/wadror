class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # defines method to be used visile in views
  helper_method :current_user, :get_place_location_as_https, :is_user_member_of_club

  def current_user
    return nil if session[:user_id].nil?
    User.find_by_id(session[:user_id])
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice:'you should be signed in' if current_user.nil?
  end

  def ensure_that_signed_in_as_admin
    redirect_to signin_path, notice:'you should be signed in as admin' if current_user.nil?
    redirect_to signin_path, notice:'you should be signed in as admin' unless current_user.admin
  end

  def get_place_location_as_https
    place = set_place
    return place.blogmap unless Rails.env.production?

    url_for(host: place.blogmap, protocol:"https")
  end

  def is_user_member_of_club
    @membership.beer_club.users.find { |user| user.username == current_user.username}
  end
end
