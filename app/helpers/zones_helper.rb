module ZonesHelper

  # Calls methode defined in ApplicationController
  def create_zone_if_doesnt_exists lat, long
    if !validate_decimal_coordinates(lat, long)
      return false
    end
    lt = get_zone_coordinates(lat)
    lg = get_zone_coordinates(long)
    if Zone.where(latitude: lt, longitude: lg).limit(1).empty?
      z = Zone.new(latitude: lt, longitude: lg)
      return false if !z.save()
    end
    return true
  end

end
