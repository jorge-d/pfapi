class UsersController < ApplicationController
  before_filter :getUser, only: [:edit, :show, :update, :destroy]
  before_filter :is_logged_or_redirect, only: [:edit, :show, :destroy, :logout, :update]

  def getUser
    @user = User.find_by_id(params[:id])
    if (!@user)
      redirect_to User, notice: "User not found"
      return false
    end
    @unlocked_zones = @user.unlocked_zones
    true
  end

  def destroy
    if (!@user.destroy)
      redirect_to @user, notice: "Could not delete user"
    end
    redirect_to User, notice: "User deleted"
  end

  def logout
    session.delete :user
    redirect_to :signin, notice: "You are not logged in anymore"
  end

  def signin
    if params[:user]
      user = User.where(name: params[:user][:name]).first
      if !user
        flash[:notice] = "User not found"
      elsif user.password != params[:user][:password]
        flash[:notice] = "Wrong password"
      else
        session[:user] = user
        redirect_to user
        return
      end
    end
  end

  def create
    @user = User.new(params[:user]);
    if @user.save
      session[:user] = @user
      redirect_to @user, notice: "User successfully created"
    else
      render :new
    end
  end

  def new
    if self.is_logged
      redirect_to session[:user], notice: "You are already logged in"
    else
      @user = User.new
    end
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: "edit"
    end
  end

  def edit
  end

  def show
    @best_scores = @user.scores.order("value DESC").limit(10)
  end

  def index
    @users = User.all
    @zones = Zone.all
  end
end
