module UnlockedZonesHelper

  # check if user already went in the zone and if not it saves it into
  def user_has_already_visited_zone user, zone
    if !UnlockedZone.where(user_id: user, zone_id: zone).limit(1).empty?
      return true
    end
    uz = UnlockedZone.new(user: user, zone: zone)
    !uz.save()
    return false
  end
end
