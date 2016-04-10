module MessageBroker
  class API < Grape::API
    version 'v1', using: :header, vendor: 'human api'
    format :json


    resource :queues do

      ### Queue Management
      
      # GET /queues
      desc 'Return the list of queues'
      get do
        CustomQueue.all
      end

      # POST /queues
      desc 'Create a queue.'
      params do
        requires :name, type: String, desc: 'Queue name'
      end
      post do
        new_queue = CustomQueue.create!(name: params[:name])
        {'status': 'ok', 'id': new_queue.id.to_s }
      end

      # PUT /queues/:id
      desc 'Modify an existing queue.'
      params do
        requires :id, type: String, desc: 'Queue ID.'
        requires :name, type: String, desc: 'Queue name.'
      end
      put ':id' do
        CustomQueue.find(params[:id]).update(name: params[:name])
        {'status': 'ok'}
      end

      # DELETE /queues/:id
      desc 'Delete an existing queue.'
      params do
        requires :id, type: String, desc: 'Queue ID.'
      end
      delete ':id' do
        CustomQueue.find_by_id(params[:id]).destroy
        {'status': 'ok'}
      end


      ### Publish Messages

      # POST /queues/:id/messages
      desc 'Sends new message to all registered consumers of a queue'
      params do 
        requires :id, type: String, desc: 'Queue ID.'
        requires :body, type: String, desc: 'message body (text)'
      end
      post ':id/messages' do
        queue = CustomQueue.find(params[:id])
        queue.consumers.each do |consumer|
          # send message to callback url with body & timestamps
        end
        {'status': 'ok'}
      end


      ### Consume Messages

      # POST /queues/:id/consumers
      desc 'Registers a new consumer to a queue.'
      params do 
        requires :id, type: String, desc: 'Queue ID.'
        requires :callback_url, type: String, desc: 'URL for receiving messages.'
      end
      post ':id/consumers' do
        queue = CustomQueue.find(params[:id])
        queue.consumers.create!(callback_url: params[:callback_url])
        {'status': 'ok'}
      end

      # GET /queues/:id/consumers
      desc 'Return the list of consumers for a queue'
      params do 
        requires :id, type: String, desc: 'Queue ID.'
      end
      get ':id/consumers' do
        queue = CustomQueue.find(params[:id])
        queue.consumers.all
      end
      
      # DELETE /queues/:id/consumers/:consumer_id
      desc 'Delete an existing consumer.'
      params do
        requires :id, type: String, desc: 'Queue ID.'
        requires :consumer_id, type: String, desc: 'Consumer ID.'
      end
      delete ':id/consumers/:consumer_id' do
        queue = CustomQueue.find_by_id(params[:id])
        queue.consumers.find_by_id(params[:consumer_id]).destroy
        {'status': 'ok'}
      end
    end


  end
end

