class Zone < ActiveRecord::Base
  has_many :unlocked_zones, dependent: :destroy
  has_many :scores, dependent: :destroy
  has_many :last_positions, dependent: :destroy

  validates :latitude, presence: true
  validates :longitude, presence: true

  def best_scores_in_zone game, nb
    self.scores.where(game_id: game).order(:value).limit(nb)
  end
end
