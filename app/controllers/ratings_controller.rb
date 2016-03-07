class RatingsController < ApplicationController
  before_action :skip_if_cached, only:[:index]

  def index
    Rails.cache.write("ratings all", Rating.all) if cache_does_not_contain_data_or_it_is_too_old("ratings all")
    @ratings = Rails.cache.read "ratings all"

    Rails.cache.write("ratings last five", Rating.last_five) if cache_does_not_contain_data_or_it_is_too_old("ratings last five")
    @newest_ratings = Rails.cache.read "ratings last five"

    Rails.cache.write("brewery top 3", Brewery.top) if cache_does_not_contain_data_or_it_is_too_old("brewery top 3")
    @best_breweries = Rails.cache.read "brewery top 3"

    Rails.cache.write("beer top 3", Beer.top) if cache_does_not_contain_data_or_it_is_too_old("beer top 3")
    @best_beers = Rails.cache.read "beer top 3"

    Rails.cache.write("user top 3", User.top) if cache_does_not_contain_data_or_it_is_too_old("user top 3")
    @users = Rails.cache.read "user top 3"

    Rails.cache.write("style top 3", Style.top) if cache_does_not_contain_data_or_it_is_too_old("style top 3")
    @best_styles = Rails.cache.read "style top 3"
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.create params.require(:rating).permit(:score, :beer_id)

    if current_user.nil?
      redirect_to signin_path, notice:'you should be signed in'
    elsif @rating.save
      current_user.ratings << @rating
      redirect_to ratings_path
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end

  def skip_if_cached
    return render :index if fragment_exist?( 'beerlist' )
  end

  def cache_does_not_contain_data_or_it_is_too_old(key)
    not Rails.cache.read(key)
  end

end