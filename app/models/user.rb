class User < ActiveRecord::Base
  require 'digest/md5'

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

  def as_json
    "penis"
  end

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
end
