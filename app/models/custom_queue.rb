class CustomQueue < ActiveRecord::Base
  has_many :messages
  has_many :consumers
end
