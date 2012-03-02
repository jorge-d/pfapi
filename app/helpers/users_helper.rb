module UsersHelper
  def set_last_player_position user, zone
    u = user.last_position
    if u
      u.zone = zone
      u.save()
    else
      u = LastPosition.new
      u.user = user
      u.zone = zone
      u.save()
    end
  end
end
