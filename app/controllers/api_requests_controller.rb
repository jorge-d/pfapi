class ApiRequestsController < ApplicationController
  include UnlockedZonesHelper
  include ZonesHelper

  before_filter :getAndCheckUser, only: [:sendScoreFromPlayer, :getScoreFromPlayer, :getZoneId, :getUnlockedZones]
  before_filter :getAndCheckCoordinates, only: [:getZoneId, :sendScoreFromPlayer]
  before_filter :getAndCheckGame, only: :sendScoreFromPlayer

  ##############
  # VALIDATORS #
  ##############
  
  def getAndCheckUser
    if !params[:user_id] or !(@user = User.find_by_id(params[:user_id]))
      render json: "User not found"
      return false
    end
    return true
  end
  
  def getAndCheckCoordinates
    if !params[:lat] or !params[:long]
      render json: "Missing coordinates"
      return false
    end
    lat = params[:lat].to_f
    long = params[:long].to_f
    # don't need to convert params before sending (already done in function)
    if !(hash = create_zone_if_doesnt_exists lat, long)
      render json: "Invalid coordinates"
      return false
    end
    @latitude = get_zone_coordinates(lat)
    @longitude = get_zone_coordinates(long)
    @zone = Zone.where(latitude: @latitude, longitude: @longitude).first
    if !@zone
      render json: "Something bad happened in getAndCheckCoordinates..."
      return false
    end
    return true
  end

  def getAndCheckGame
    if !params[:game_id] or !(@game = Game.find_by_id(params[:game_id]))
      render json: "Game not found"
      return false
    else
      return true
    end
  end
  
  ###############
  # \VALIDATORS #
  ###############
  
  def getZoneId
    answer = user_has_already_visited_zone(@user, @zone) # unlocks Zone if users never went there
    hash = [unlocked_zone: @zone, already_visited: answer]
    render json: hash
  end

  def getUnlockedZones
    res = @user.unlocked_zones.map {
      |z| [zone_id: z.zone.id, latitude: z.zone.latitude, longitude: z.zone.longitude] }
    render json: res
  end

  def getScoreFromZone
    if !params[:zone_id]
      render json: "Missing parameter zone_id"
      return
    end
    z = Zone.find_by_id(params[:zone_id])
    if !z
      render json: "Invalid zone"
      return
    end
    sc = z.scores
    res = sc.limit(10) # do not forget to check game
    render json: res
  end

  def getScoreFromPlayer
    sc = @user.scores
    res = sc.limit(10) # do not forget to check game
    render json: res
  end
  
  def sendScoreFromPlayer
    if !params[:value]
      render json: "Missing parameter value"
      return
    end
    res = @user.unlocked_zones.where(zone_id: @zone).first
    if res
      @score = Score.new
      @score.value = params[:value].to_i
      @score.user = @user
      @score.zone = @zone
      @score.game = @game
      if !@score.save
        render json: @score.errors
      else
        render json: @score
      end
    else
      render json: "Zone was never Unlocked"
    end
  end
end
