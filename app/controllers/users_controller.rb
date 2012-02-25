class UsersController < ApplicationController
  before_filter :getUser, only: [:edit, :show, :update, :destroy]

  def getUser
    @user = User.find_by_id(params[:id])
    if (!@user)
      redirect_to User, notice: "User not found"
      false
    end
    true
  end

  def destroy
    if (!@user.destroy)
      redirect_to @user, notice: "Could not delete user"
    end
    redirect_to User, notice: "User deleted"
  end

  def create
    @user = User.new(params[:user]);
    if @user.save
      redirect_to @user, notice: "User successfully created"
    else
      render :new
    end
  end

  def new
    @user = User.new
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
  end

  def index
    @lat = params[:lat].to_f
    @long = params[:long].to_f
    if (!validate_decimal_coordinates(@lat, @long))
      render json: "invalid coordinates"
      return
    end
    lt = get_zone_coordinates(@lat)
    lg = get_zone_coordinates(@long)
    if Zone.where(latitude: lt, longitude: lg).limit(1).empty?
      z = Zone.new(latitude: lt, longitude: lg)
      render json: "couldnt save zone" if !z.save()
    end
    @answer = [lt, lg]
    @users = User.all
    @zones = Zone.all
  end
end
