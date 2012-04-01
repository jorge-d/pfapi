class Game < ActiveRecord::Base
  require 'digest/md5'
  has_many :scores, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 15 }
  before_create :generate_api_key
  
  def generate_api_key
    self.api_key = rand(36**8).to_s(36)
  end
end
