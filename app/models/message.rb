class Message < ActiveRecord::Base
  belongs_to :custom_queue
end
