class UnlockedZone < ActiveRecord::Base
  belongs_to :user
  belongs_to :zone

  validates :user_id, presence: true
  validates :zone_id, presence: true
end
