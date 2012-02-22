class Score < ActiveRecord::Base
  belongs_to :zone
  belongs_to :user
end
