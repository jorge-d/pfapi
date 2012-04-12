class Score < ActiveRecord::Base
  belongs_to :zone
  belongs_to :user
  belongs_to :game

  validates :value, presence: true, inclusion: { :in => 1..9999, message: "can only be between 1 and 9999." }
  validates :user_id, presence: true
  validates :zone_id, presence: true
  validates :game_id, presence: true

  scope :best, order('value DESC').limit(1)

  scope :recents, order('updated_at DESC')

  scope :last_from_user, lambda {
    |user, fromtime| Score.where(user_id: user).order("updated_at DESC").where("updated_at > ?", fromtime).limit(1)
  }

  before_save :check_flood

  def check_flood
    if !Score.last_from_user(self.user, 5.seconds.ago).empty?
      return false
    else
      return true
    end
  end
end
