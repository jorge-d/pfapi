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

  # Don't need to use what is above
  # def show
  #   @score = Score.find_by_id(params[:id]);
  # end
  # 
  # def destroy
  #   if (!@score.destroy)
  #     redirect_to @score, notice: "Could not delete score"
  #   end
  #   redirect_to Score, notice: "Score deleted"
  # end
  # 
  # def create
  #   @score = Score.new(value: params[:score][:value].to_i);
  #   @score.user = User.find_by_id(params[:user_id]);
  #   @score.zone = Zone.find_by_id(1)
  #   @score.game = Game.find_by_id(1)
  #   @users_array = User.all.map { |user| [user.name, user.id] }
  # 
  #   if !@score.check_flood
  #     flash[:notice] = "Flood Protection"
  #   elsif @score.save
  #     redirect_to @score, notice: "Score created"
  #     return
  #   end
  #   render :new
  # end
  # 
  # def new
  #   @users = User.all
  #   @score = Score.new
  #   @users_array = @users.map { |user| [user.name, user.id] }
  # end
  # 
  # def edit
  # end
  # 
  # def update
  # end
end
