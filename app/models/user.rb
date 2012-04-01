class User < ActiveRecord::Base
  require 'digest/md5'
  include ZonesHelper

  has_many :scores, dependent: :destroy
  has_many :unlocked_zones, dependent: :destroy
  has_one :user_key, dependent: :destroy
  has_one :last_position, dependent: :destroy

  validates_format_of :name, with: /^[-\w\_]+$/i, :allow_blank => false, :message => "should only contain letters, numbers, or -_"
  validates_format_of :email, with: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i, message: "Bad format"

  validates :name,  presence: true, uniqueness: true, length: { minimum: 4, maximum: 15 }
  validates :password, presence: true, length: { minimum: 2, maximum: 10 }
  validates :email, presence: true, uniqueness: true

  attr_protected :salt

  before_save :encrypt_password


  def encrypt_string str
    return Digest::MD5::hexdigest([self.name, self.salt.to_s, str].join(":"))
  end

  def encrypt_password
    self.salt = rand(99)
    self.encrypted_password = Digest::MD5::hexdigest([name, salt.to_s, password].join(":"))
  end
  
  def best_scores_by_game game, nb
    self.scores.where(game_id: game).order("value DESC").limit(nb)
  end
  
  # check if user already went in the zone and if not it saves it into
  def checkout_zone zone
    if !UnlockedZone.where(user_id: self, zone_id: zone).limit(1).empty?
      return true
    end
    UnlockedZone.create(user: self, zone: zone)
    return false
  end
  
  def get_total_score game
    res = 0
    self.scores.each do |t|
      if t.game == game
        res += t.value
      end
    end
    res
  end
  
  def set_last_position zone
    if self.last_position
      self.last_position.update_attributes(zone: zone)
    else
      LastPosition.create(user: self, zone: zone)
    end
  end
  
  def get_unlocked_zones
    self.unlocked_zones.map {|z| {zone_id: z.zone.id, latitude: z.zone.latitude, longitude: z.zone.longitude}}
  end

  def unlock_zones_arround zone
    self.set_last_position(zone)
    
    hash = [[zone.latitude - 0.1, zone.longitude - 0.1], [zone.latitude - 0.1, zone.longitude],
            [zone.latitude - 0.1, zone.longitude + 0.1], [zone.latitude, zone.longitude - 0.1],
            [zone.latitude, zone.longitude + 0.1], [zone.latitude + 0.1, zone.longitude - 0.1],
            [zone.latitude + 0.1, zone.longitude], [zone.latitude + 0.1, zone.longitude + 0.1]]
    res = Array.new
    hash.each do |h|
      if !(zone = create_zone_if_doesnt_exists(h[0], h[1]))
        render json: "Error creating zone"
        return
      end
      if !self.checkout_zone(zone)
        res << {id: zone.id, latitude: zone.latitude, longitude: zone.longitude}
      end
    end
    res
  end
end
