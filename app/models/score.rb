class Score < ActiveRecord::Base
  belongs_to :zone
  belongs_to :user

  validates :value, presence: true, inclusion: { :in => 1..99, message: "can only be between 1 and 99." }
  validates :user_id, presence: true
  validates :zone_id, presence: true

  scope :last_from_zone_and_user, lambda {
    |user, zone, fromtime| Score.where(zone_id: zone, user_id: user).order("updated_at DESC").where("updated_at > ?", fromtime).limit(1)
  }

end
