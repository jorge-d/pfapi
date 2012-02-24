class User < ActiveRecord::Base
  has_many :score, dependent: :destroy
  has_many :unlocked_zone, dependent: :destroy

  validates_format_of :name, with: /^[-\w\_]+$/i, :allow_blank => false, :message => "should only contain letters, numbers, or -_"
  validates_format_of :email, with: /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i, message: "Bad format"

  validates :name,  presence: true, uniqueness: true, length: { minimum: 4, maximum: 15 }
  validates :password, presence: true, length: { minimum: 2, maximum: 10 }
  validates :email, presence: true, uniqueness: true
end
