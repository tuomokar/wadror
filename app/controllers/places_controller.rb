class PlacesController < ApplicationController
  def index
  end

  def search
    @places = BeerMappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end
end