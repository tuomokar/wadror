class PlacesController < ApplicationController
  before_action :set_place, only:[:show, :destroy]
  def index
  end

  def show

  end

  def destroy
  end

  def search
    @places = BeerMappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      session[:city] = params[:city]

      render :index
    end
  end

  private
    def find_place_by_city(places, city)
      places.find { |place| place.city === city}
    end

    def set_place
      id = params[:id]
      places = BeerMappingApi.places_in(session[:city])

      #@place = Place.new (places.find id)
      @place = places.find { |place| place.id.eql? id}

    end
end