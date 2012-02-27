class Zone < ActiveRecord::Base
  has_many :unlocked_zones, dependent: :destroy
  has_many :scores, dependent: :destroy

  validates :latitude, presence: true
  validates :longitude, presence: true

end
