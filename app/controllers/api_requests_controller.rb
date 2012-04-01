class ApiRequestsController < ApplicationController
  include UnlockedZonesHelper
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
    :checkout_score, :best_score_from_player, :score_from_zone_by_id, :total_score_from_player
    ]

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
    if !params[:latitude] or !params[:longitude]
      render json: "Missing coordinates (params latitude=X&longitude=X)"
      return false
    end
    lat = params[:latitude].to_f
    long = params[:longitude].to_f
    if !(@zone = create_zone_if_doesnt_exists lat, long)
      render json: "Invalid coordinates: read http://www.sunearthtools.com/dp/tools/conversion.php?lang=fr"
      return false
    end
    @latitude = get_zone_coordinates(lat)
    @longitude = get_zone_coordinates(long)
    return true
  end

  # check if the game api_key is ok (for scores and other small things)
  def getAndCheckGame
    if !params[:game_id]
      render json: "Missing game_id (params game_id=X)"
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
  def checkout_zone
    answer = user_has_already_visited_zone(@user, @zone) # unlocks Zone if users never went there
    set_last_player_position(@user, @zone)
    render json: {unlocked_zone: @zone, already_visited: answer}
  end

  # returns an array containing all the zones unlocked by the user
  def unlocked_zones
    res = @user.unlocked_zones.map {
      |z| [zone_id: z.zone.id, latitude: z.zone.latitude, longitude: z.zone.longitude] }
    render json: res
  end

  # returns the number of zone unlocked (may be used for ingame bonuses)
  def unlocked_zones_number
    render json: {unlocked_zones: @user.unlocked_zones.count}
  end

  # get the 10 best scores from zone
  def score_from_zone_by_id
    if !params[:zone_id]
      render json: "Missing parameter zone_id"
    else
      z = Zone.find_by_id(params[:zone_id])
      if !z
        render json: "Invalid zone"
      else
        sc = z.scores
        res = sc.where(game_id: @game).order(:value).limit(10)
        render json: res
      end
    end
  end

  # get zone informations by its ID
  def zone_informations_by_id
    if !params[:zone_id]
      render json: "Missing parameter zone_id"
    else
      z = Zone.find_by_id(params[:zone_id])
      if !z
        render json: "Zone not found"
      else
        render json: z # need a beter format
      end
    end
  end

  # get the bests score from player
  def best_score_from_player
    if params[:nb].to_i > 0
      nb = params[:nb].to_i
    else
      nb = 10;
    end
    render json: @user.best_scores_by_game(@game, nb)
  end
  
  def total_score_from_player
    s = @user.scores
    res = 0
    s.each do |t|
      res += t.value
    end
    render json: {totalscore: res}
  end

  # checkout the score on the zone and for the game passed on parameters
  def checkout_score
    if !params[:value]
      render json: "Missing parameter value"
    elsif !(params[:value].to_i > 0)
      render json: "Bad value"
    else
      if !@user.unlocked_zones.where(zone_id: @zone).first
        render json: "You need to unlock the zone first"
      else
        set_last_player_position(@user, @zone)
        @score = Score.new
        @score.value = params[:value].to_i
        @score.user = @user
        @score.zone = @zone
        @score.game = @game
        if !@score.save
          render json: {error: @score.errors}
        else
          render json: @score
        end
      end
    end
  end

  # get the users's key
  def credentials
    if !params[:login]
      ret = "login missing"
    elsif !params[:password]
      ret = "password missing"
    else
      user = User.where(name: params[:login]).limit(1).first
      if !user
        ret = "User not found"
      else
        tmp = user.encrypt_string(params[:password])
        if tmp == user.encrypted_password
          ret = {key: user.encrypted_password}
        else
          ret = "Invalid password"
        end
      end
    end
    render json: ret
  end

  def unlock_zones_arround
    if !@user.unlocked_zones.where(zone_id: @zone).first
      render json: "This zone is still locked for you"
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

  def players_in_zone
    u = @zone.last_positions
    res = Hash.new
    i = 0
    u.each do |t|
      res[i] = {login: t.user.name, last_seen: t.user.updated_at}
      i = i + 1
    end
    render json: res
  end
end
