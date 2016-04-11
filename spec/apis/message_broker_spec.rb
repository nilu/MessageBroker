require 'rails_helper'

describe MessageBroker::API do
  include Rack::Test::Methods

  def app
    MessageBroker::API
  end

  context "Queues" do
    context 'GET /queues' do
      it 'returns an empty array of queues if there are none' do
        get '/queues'
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq []
      end

      it 'should return an array of queues' do
        queue1 = CustomQueue.create!(name: 'queue1')
        queue2 = CustomQueue.create!(name: 'queue2')
        queue3 = CustomQueue.create!(name: 'queue3')

        get '/queues'
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq [
          {"id"=> queue1.id, "name"=> queue1.name},
          {"id"=> queue2.id, "name"=> queue2.name},
          {"id"=> queue3.id, "name"=> queue3.name}
        ]
      end
    end

    context 'POST /queues' do
      it 'should create a new queue' do
        post "/queues", name: 'test'
        expect(last_response.status).to eq(201)
        expect(CustomQueue.where(name: 'test').count).to eq(1)
      end

      it 'should return id and status ok' do
        post "/queues", name: 'test'
        queue = CustomQueue.find_by_name('test')

        expect(JSON.parse(last_response.body)).to eq ({
          "id" => queue.id.to_s, 
          "status" => "ok",
        })
      end
    end

    context 'PUT /queues/:id' do
      before :each do
        @queue = CustomQueue.create!(name: 'test')
      end

      it 'should update an existing queue' do
        put "/queues/#{@queue.id}", name: 'nottest'
        expect(last_response.status).to eq(200)
        expect(CustomQueue.where(name: 'test').count).to eq(0)
        expect(CustomQueue.where(name: 'nottest').count).to eq(1)
      end

      it 'should return status ok' do
        put "/queues/#{@queue.id}", name: 'nottest'

        expect(JSON.parse(last_response.body)).to eq ({
          "status" => "ok",
        })
      end
    end

    context 'DELETE /queues/:id' do
      before :each do
        @queue = CustomQueue.create!(name: 'test')
      end

      it 'should delete an existing queue' do
        delete "/queues/#{@queue.id}"
        expect(last_response.status).to eq(200)
        expect(CustomQueue.where(name: 'test').count).to eq(0)
      end

      it 'should return status ok' do
        delete "/queues/#{@queue.id}"

        expect(JSON.parse(last_response.body)).to eq ({
          "status" => "ok",
        })
      end
    end
  end

  context "Messages" do
    context 'POST /queues/:id/messages' do
      before :each do
        @queue = CustomQueue.create!(name: 'test')
        @consumer = @queue.consumers.create!(callback_url: 'http://test.com')
      end

      it 'should send messages to consumers' do
        post "queues/#{@queue.id}/messages", body: 'Hello!'
        expect(last_response.status).to eq(201)
        expect(Message.where(body: 'Hello!', custom_queue_id: @queue.id).count).to eq(1)
      end

      it 'should return status ok' do
        post "queues/#{@queue.id}/messages", body: 'Hello!'
        expect(JSON.parse(last_response.body)).to eq ({
          "status" => "ok",
        })
      end
    end
  end

  context "Consumers" do
    before :each do
      @queue = CustomQueue.create!(name: 'test')
    end

    context 'POST /queues/:id/consumers' do
      it 'should create a new consumer' do
        post "queues/#{@queue.id}/consumers", callback_url: 'http://test.com!'
        expect(last_response.status).to eq(201)
        expect(Message.where(body: 'Hello!').count).to eq(0)
      end

      it 'should return status ok' do
        post "queues/#{@queue.id}/consumers", callback_url: 'http://test.com!'
        expect(JSON.parse(last_response.body)).to eq ({
          "status" => "ok",
        })
      end
    end

    context 'GET /queues/:id/consumers' do
      it 'should return an array of all consumers' do
        consumer1 = @queue.consumers.create!(callback_url: 'http://test1.com')
        consumer2 = @queue.consumers.create!(callback_url: 'http://test2.com')
        consumer3 = @queue.consumers.create!(callback_url: 'http://test3.com')

        get "queues/#{@queue.id}/consumers"
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq [
          {"id"=> consumer1.id, "custom_queue_id" => consumer1.custom_queue_id, "callback_url"=> consumer1.callback_url},
          {"id"=> consumer2.id, "custom_queue_id" => consumer2.custom_queue_id, "callback_url"=> consumer2.callback_url},
          {"id"=> consumer3.id, "custom_queue_id" => consumer3.custom_queue_id, "callback_url"=> consumer3.callback_url}
        ]
      end
    end

    context 'DELETE /queues/:id/consumers/:consumer_id' do
      before :each do
        @consumer = @queue.consumers.create!(callback_url: 'http://test.com')
      end
      it 'should delete the consumer' do
        delete "queues/#{@queue.id}/consumers/#{@consumer.id}"
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq ({
          "status" => "ok",
        })
      end
    end
  end
end
