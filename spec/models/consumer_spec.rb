require 'rails_helper'

describe Consumer do
  it { should validate_presence_of(:custom_queue_id) }
  it { should validate_presence_of(:callback_url) }
  it { should allow_value('http://test.com').for(:callback_url)}
  it 'should fail if queue does not exist' do
    new_consumer = Consumer.create(custom_queue_id: 1, callback_url: 'http://test.com')
    new_consumer.should_not be_valid
  end

  it 'should pass if queue exists' do
    queue = CustomQueue.create!(name: 'name')
    new_consumer = Consumer.create(custom_queue_id: queue.id, callback_url: 'http://test.com')
    new_consumer.should be_valid
  end
end
