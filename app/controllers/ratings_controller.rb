class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
    @newest_ratings = Rating.last_five
    @best_breweries = Brewery.top
    @best_beers = Beer.top
    @users = User.top
    @best_styles = Style.top
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
end