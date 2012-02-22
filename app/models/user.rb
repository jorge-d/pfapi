class User < ActiveRecord::Base
  has_many :score
  has_many :unlocked_zone

  validates :name,  presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 2, maximum: 10 }
  validates :email, presence: true
end
