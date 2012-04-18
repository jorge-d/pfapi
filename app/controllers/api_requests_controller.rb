class ApiRequestsController < ApplicationController
  include ZonesHelper
  include UsersHelper

  before_filter :getAndCheckUser, only: [
    :checkout_score, :best_score_from_player, :unlock_zones_arround, :unlocked_zones, :unlocked_zones_number,
    :checkout_zone, :total_score_from_player
    ]
  before_filter :getAndCheckCoordinates, only: [
    :unlock_zones_arround, :checkout_score, :checkout_zone, :players_in_zone
    ]
  before_filter :getAndCheckGame, only: [
    :checkout_score, :best_score_from_player, :best_score_from_zone_by_id, :total_score_from_player
    ]

  def documentation
  end

  ##############
  # VALIDATORS #
  ##############

  # check if the user is correct
  def getAndCheckUser
    if !params[:user_key]
      render json: {error: "Missing user_key"}
    elsif !(@user = User.where(encrypted_password: params[:user_key]).first)
      render json: {error: "User not found"}
    else
      return true
    end
    return false
  end

  # check if the coordinates are good and create zone if i doesn't exists, then get it
  def getAndCheckCoordinates
    if !params[:latitude] or !params[:longitude]
      render json: {error: "Missing coordinates (params latitude=X&longitude=X)"}
      return false
    end
    lat = params[:latitude].to_f
    long = params[:longitude].to_f
    if !(@zone = create_zone_if_doesnt_exists(lat, long))
      render json: {error: "Invalid coordinates: read http://www.sunearthtools.com/dp/tools/conversion.php?lang=fr"}
      return false
    end
    @latitude = get_zone_coordinates(lat)
    @longitude = get_zone_coordinates(long)
    return true
  end

  # check if the game api_key is ok (for scores and other small things)
  def getAndCheckGame
    if !params[:game_id]
      render json: {error: "Missing game_id (params game_id=X)"}
    elsif !(@game = Game.where(api_key: params[:game_id]).first)
      render json: {error: "Game not found"}
    else
      return true
    end
    return false
  end
  
  ###############
  # \VALIDATORS #
  ###############

  # checkout the current zone and unlock it
  def checkout_zone
    answer = @user.checkout_zone @zone
    @user.set_last_position @zone
    render json: {unlocked_zone: @zone, already_visited: answer}
  end

  # returns an array containing all the zones unlocked by the user
  def unlocked_zones
    render json: @user.get_unlocked_zones
  end

  # returns the number of zone unlocked (may be used for ingame bonuses)
  def unlocked_zones_number
    render json: {unlocked_zones_number: @user.unlocked_zones.count}
  end

  # get the best scores from zone
  def best_score_from_zone_by_id
    if !params[:zone_id]
      render json: {error: "Missing parameter zone_id"}
    else
      zone = Zone.find_by_id(params[:zone_id])
      if !zone
        render json: {error: "Invalid zone"}
      else
        params[:nb] ||= 10
        render json: zone.best_scores_in_zone(@game, params[:nb])
      end
    end
  end

  # get zone informations by its ID
  def zone_informations_by_id
    if !params[:zone_id]
      render json: {error: "Missing parameter zone_id"}
    else
      z = Zone.find_by_id(params[:zone_id])
      if !z
        render json: {error: "Zone not found"}
      else
        render json: z # need a beter format
      end
    end
  end

  # get the bests score from player
  def best_score_from_player
    params[:nb] ||= 10
    render json: @user.best_scores_by_game(@game, params[:nb])
  end
  
  def total_score_from_player
    render json: {totalscore: @user.get_total_score(@game)}
  end

  # checkout the score on the zone and for the game passed on parameters
  def checkout_score
    if !(params[:value].to_i > 0)
      render json: {error: "Bad value"}
    else
      if !@user.unlocked_zones.where(zone_id: @zone).first
        render json: {error: "You need to unlock the zone first"}
      else
        @user.set_last_position(@zone)
        @score = Score.create(value: params[:value].to_i, user: @user, zone: @zone, game: @game)
        render json: @score
      end
    end
  end

  # get the users's key
  def credentials
    if !params[:login]
      ret = {error: "login missing"}
    elsif !params[:password]
      ret = {error: "password missing"}
    else
      user = User.where(name: params[:login]).limit(1).first
      if !user
        ret = {error: "User not found"}
      else
        tmp = user.encrypt_string(params[:password])
        if tmp == user.encrypted_password
          ret = {key: user.encrypted_password}
        else
          ret = {error: "Invalid password"}
        end
      end
    end
    render json: ret
  end

  def unlock_zones_arround
    if !@user.unlocked_zones.where(zone_id: @zone).first
      render json: {error: "This zone is still locked for you"}
      return
    end
    ret = @user.unlock_zones_arround(@zone)
    render json: {new_zone_unlocked: ret.count, results: ret}
  end

  def players_in_zone
    u = @zone.last_positions
    res = Array.new
    u.each do |t|
      res << {login: t.user.name, last_seen: t.user.updated_at}
    end
    render json: res
  end
end
