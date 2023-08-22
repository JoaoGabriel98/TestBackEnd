class CitiesController < ApplicationController
  # GET /cities or /cities.json
  def index
    @cities = City.all
    @states = State.all.pluck(:name, :id)
  end

  def search
    # Apply filters based on received parameters
    @cities = City.select('cities.name as city', 'states.name as state', :state_id).joins(:state)
    @cities = @cities.where("cities.name LIKE ?", "%#{params[:city]}%") if params[:city]
    @cities = @cities.where("states.id = ?", params[:state]) if params[:state]

    render json: @cities
  end
end
