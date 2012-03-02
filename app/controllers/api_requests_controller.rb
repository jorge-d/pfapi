class ApiRequestsController < ApplicationController
  include UnlockedZonesHelper
  include ZonesHelper
  include UsersHelper

  before_filter :getAndCheckUser, only: [
    :sendScoreFromPlayer, :getScoreFromPlayer, :getZoneId, :getUnlockedZones, :getUnlockedZonesNumber,
    :unlockZonesArround
    ]
  before_filter :getAndCheckCoordinates, only: [
    :getZoneId, :sendScoreFromPlayer, :unlockZonesArround, :getPlayersInZone
    ]
  before_filter :getAndCheckGame, only: [:sendScoreFromPlayer, :getScoreFromPlayer, :getScoreFromZone]

  ##############
  # VALIDATORS #
  ##############

  # check if the user is correct
  def getAndCheckUser
    if !params[:user_id]
      render json: "Missing user_id"
    elsif !(@user = User.where(encrypted_password: params[:user_id]).first)
      render json: "User not found"
    else
      return true
    end
    return false
  end

  # check if the coordinates are good and create zone if i doesn't exists, then get it
  def getAndCheckCoordinates
    if !params[:lat] or !params[:long]
      render json: "Missing coordinates"
      return false
    end
    lat = params[:lat].to_f
    long = params[:long].to_f
    # don't need to convert params before sending (already done in function)
    if !(@zone = create_zone_if_doesnt_exists lat, long)
      render json: "Invalid coordinates"
      return false
    end
    @latitude = get_zone_coordinates(lat)
    @longitude = get_zone_coordinates(long)
    return true
  end

  # check if the game api_key is ok (for scores and other small things)
  def getAndCheckGame
    if !params[:game_id]
      render json: "Missing game_id"
    elsif !(@game = Game.where(api_key: params[:game_id]).first)
      render json: "Game not found"
    else
      return true
    end
    return false
  end
  
  ###############
  # \VALIDATORS #
  ###############

  # checkout the current zone and unlock it
  def getZoneId
    answer = user_has_already_visited_zone(@user, @zone) # unlocks Zone if users never went there
    set_last_player_position(@user, @zone)
    render json: {unlocked_zone: @zone, already_visited: answer}
  end

  # returns an array containing all the zones unlocked by the user
  def getUnlockedZones
    res = @user.unlocked_zones.map {
      |z| [zone_id: z.zone.id, latitude: z.zone.latitude, longitude: z.zone.longitude] }
    render json: res
  end

  # returns the number of zone unlocked (may be used for ingame bonuses)
  def getUnlockedZonesNumber
    render json: {unlocked_zones: @user.unlocked_zones.count}
  end

  # get the 10 latests scores from the game and zone passed on parameters
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
    res = sc.where(game_id: @game).limit(10)
    render json: res
  end

  # get zone informations by its ID
  def getZoneById
    if !params[:zone_id]
      render json: "Missing parameter zone_id"
      return
    end
    z = Zone.find_by_id(params[:zone_id])
    if !z
      render json: "Zone not found"
      return
    end
    render json: {zone: z} # need a beter format
  end

  # get the 10 bests score from player
  def getScoreFromPlayer
    sc = @user.scores
    if (params[:nb])
      res = sc.where(game_id: @game).order("value DESC").limit(params[:nb].to_i)
    else
      res = sc.where(game_id: @game).order("value DESC").limit(10)
    end
    render json: res
  end
  
  # checkout the score on the zone and for the game passed on parameters
  def sendScoreFromPlayer
    if !params[:value]
      render json: "Missing parameter value"
      return
    end
    if @user.unlocked_zones.where(zone_id: @zone).first
      set_last_player_position(@user, @zone)
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
      render json: "You need to unlock the zone first"
    end
  end
  
  # get the users's key
  def getCredentials
    if !params[:login]
      render json: "login missing"
    elsif !params[:password]
      render json: "password missing"
    end
    user = User.where(name: params[:login]).limit(1).first
    if !user
      render json: "User not found"
    else
      tmp = user.encrypt_string(params[:password])
      if tmp == user.encrypted_password
        render json: {key: user.encrypted_password}
      else
        render json: "Invalid password"
      end
    end
  end
  
  def unlockZonesArround
    if !@user.unlocked_zones.where(zone_id: @zone).first
      render json: "You did not have unlocked the zone"
      return
    end
    
    set_last_player_position(@user, @zone)
    tmp = @user.unlocked_zones.count
    hash = [[@zone.latitude - 0.1, @zone.longitude - 0.1], [@zone.latitude - 0.1, @zone.longitude],
            [@zone.latitude - 0.1, @zone.longitude + 0.1], [@zone.latitude, @zone.longitude - 0.1],
            [@zone.latitude, @zone.longitude + 0.1], [@zone.latitude + 0.1, @zone.longitude - 0.1],
            [@zone.latitude + 0.1, @zone.longitude], [@zone.latitude + 0.1, @zone.longitude + 0.1]]
    i = 0
    res = Hash.new
    hash.each do |h|
      if !(z = create_zone_if_doesnt_exists(h[0], h[1]))
        render json: "Error creating zone"
        return
      end
       # unlocks Zone if users never went there
      if user_has_already_visited_zone(@user, z)
        res[i] = {id: z.id, latitude: z.latitude, longitude: z.longitude}
        i = i + 1
      end
    end
    tmp = @user.unlocked_zones.count - tmp
    render json: {new_zone_unlocked: tmp, results: res}
  end

  def getPlayersInZone
    a = @zone.last_positions
    render json: a
  end
end
