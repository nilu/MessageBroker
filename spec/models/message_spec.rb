require 'rails_helper'

describe Message do
  it { should validate_presence_of(:custom_queue_id) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:timestamp) }

  it 'should fail if queue does not exist' do
    new_consumer = Message.create(custom_queue_id: 1, body: 'message', timestamp: Time.now.to_i)
    new_consumer.should_not be_valid
  end

  it 'should pass if queue exists' do
    queue = CustomQueue.create!(name: 'name')
    new_consumer = Message.create(custom_queue_id: queue.id, body: 'message', timestamp: Time.now.to_i)
    new_consumer.should be_valid
  end

end
