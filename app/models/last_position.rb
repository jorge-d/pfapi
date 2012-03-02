class LastPosition < ActiveRecord::Base
  belongs_to :user
  belongs_to :zone

  validates :user_id, presence: true, uniqueness: true
  validates :zone_id, presence: true
end
