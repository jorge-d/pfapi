class UnlockedZonesController < ApplicationController
  before_filter :get_player

  def get_player
    @user = User.find(params[:user_id])
    return false if !@user
    true
  end

  def index
    @unlocked_zones = @user.unlocked_zones.order("updated_at DESC")
  end
end
