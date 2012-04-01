class ZonesController < ApplicationController
  def index
    @zones = Zone.all
    
    # render json: @zones
  end
  
  def show
    @zone = Zone.find(params[:id])
    @scores = @zone.scores.order("value DESC")
  end
end
