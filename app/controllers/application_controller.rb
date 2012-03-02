class ApplicationController < ActionController::Base
  protect_from_forgery

  def routing_error
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404.html", status: :not_found }
      format.xml  { head :not_found }
      format.json  { render json: 'Not found', status: :unprocessable_entity }
      format.any  { head :not_found }
    end
    false
  end

  def validate_latitude(lat)
    deg = lat.to_i
    min = ((lat - deg).abs * 60).to_i
    if !(deg > -90 && deg < 90 && min >= 0 && min < 60)
      ret = false
    else
      ret = true
    end
    # res [lat, deg, min, ret]
    return ret
  end

  def validate_longitude long
    deg = long.to_i
    min = ((long - deg).abs * 60).to_i
    if !(deg > -180 && deg < 180 && min >= 0 && min < 60)
      ret = false
    else
      ret = true
    end
    # res [long, deg, min, ret]
    return ret
  end

  def validate_decimal_coordinates lat, long
    lt = self.validate_latitude(lat)
    lg = self.validate_longitude(long)
    return true if lt and lg
    return false
  end

  def get_zone_coordinates coor
    if coor >= 0
      return ((coor * 10).to_i).to_f / 10
    else
      nbf = coor.to_f
      nbi = coor.to_i
      if ((coor * 10) - (coor * 10).to_i).to_i == 0
        return (((coor * 10).to_i).to_f) / 10
      else
        return (((coor * 10).to_i).to_f - 1) / 10
      end      
    end
  end
end
