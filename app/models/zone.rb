class Zone < ActiveRecord::Base
  validates :latitude, presence: true, uniqueness: true
  validates :longitude, presence: true, uniqueness: true
end
