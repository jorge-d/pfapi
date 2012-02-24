class ScoresController < ApplicationController
  before_filter :do_nothing, only: [:edit, :update]
  before_filter :get_score, only: [:show, :destroy]

  def get_score
    @score = Score.find_by_id(params[:id]);

    if !@score
      return routing_error
    end
  end

  def do_nothing
    redirect_to Score, notice: "Action not possible"
  end

  def show
  end

  def destroy
    if (!@score.destroy)
      redirect_to @score, notice: "Could not delete score"
    end
    redirect_to Score, notice: "Score deleted"
  end

  def index
    @scores = Score.all
  end

  def create
    @score = Score.new(value: params[:score][:value].to_i);
    @score.user = User.find_by_id(params[:user_id]);
    @score.zone = Zone.find_by_id(1)
    @users_array = User.all.map { |user| [user.name, user.id] }

    if !@score.zone or !@score.user
      flash[:notice] = "Couldn't save score (undefined zone of user)"
    elsif !Score.last_from_zone_and_user(@score.user, @score.zone, 5.second.ago).empty?
      flash[:notice] = "Dont push too much"
    elsif @score.save
      redirect_to @score, notice: "Score created"
      return
    end
    render :new
  end

  def new
    @users = User.all
    @score = Score.new
    @users_array = @users.map { |user| [user.name, user.id] }
  end

  # SHALL NOT BE USED
  def edit
  end

  def update
  end
end
