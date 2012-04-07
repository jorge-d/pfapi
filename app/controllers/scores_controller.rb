class ScoresController < ApplicationController
  before_filter :get_player

  def get_player
    @user = User.find(params[:user_id])
    return false if !@user
    true
  end

  def index
    @scores = @user.scores.recents
    # render json: @scores
  end
end
