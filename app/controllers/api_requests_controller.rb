class ApiRequestsController < ApplicationController
  include UnlockedZonesHelper
  include ZonesHelper

  def getZoneId
    if !params[:lat] or !params[:long]
      render json: "Missing parameters"
      return
    end
    lat = params[:lat].to_f
    long = params[:long].to_f
    # don't need to convert params before sending (already done in function)
    if !(hash = create_zone_if_doesnt_exists lat, long)
      render json: "invalid coordinates"
      return
    end

    u = User.find_by_id(7) # Temporary
    lat = get_zone_coordinates(lat)
    long = get_zone_coordinates(long)
    z = Zone.where(latitude: lat, longitude: long).first
    if z
      @answer = user_has_already_visited_zone(u, z)
      hash = [unlocked_zone: z, already_visited: @answer]
      render json: hash
    else
      render json: "wtf happened in api_request_controller?"
    end
  end

  def getUnlockedZones
    if !params[:user_id]
      render json: "Missing parameter user_id"
      return
    end
    u = User.find_by_id(params[:user_id])
    if u
      res = u.unlocked_zone.map {
        |z| [zone_id: z.zone.id, latitude: z.zone.latitude, longitude: z.zone.longitude] }
      render json: res
    else
      render json: "User not found"
    end
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
    if !params[:user_id]
      render json: "Missing parameter user_id"
    else
      u = User.find_by_id(params[:user_id])
      if !u
        render json: "Invalid user_id"
        return
      end
      sc = u.scores
      res = sc.limit(10) # do not forget to check game
      render json: res
    end
  end
end
