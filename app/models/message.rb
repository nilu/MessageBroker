class Message < ActiveRecord::Base
  belongs_to :custom_queue

  validates :body, presence: true
  validates :timestamp, presence: true
  validates :queue_id, presence: true
  validate :valid_queue

  private

  def valid_queue
    queue = CustomQueue.find_by_id(self.queue_id)
    if queue.nil?
      errors.add(:queue, "does not exist")
    end
  end
end
