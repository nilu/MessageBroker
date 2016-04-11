class CustomQueue < ActiveRecord::Base
  has_many :messages
  has_many :consumers

  validates :name, presence: true
  validates :name, uniqueness: true
end
