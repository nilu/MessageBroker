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
        CustomQueue.create!({
          name: params[:name]
        })
      end

      # PUT /queues/:id
      desc 'Modify an existing queue.'
      params do
        requires :id, type: String, desc: 'Queue ID.'
        requires :name, type: String, desc: 'Queue name.'
      end
      put ':id' do
        CustomQueue.find(params[:id]).update({
          name: params[:name]
        })
      end

      # DELETE /queues:id
      desc 'Delete an existing queue.'
      params do
        requires :id, type: String, desc: 'Queue ID.'
      end
      delete ':id' do
        CustomQueue.find_by_id(params[:id]).destroy
      end


      ### Publish Messages

      # POST /queues/:id/messages
      desc 'Sends new message to all registered consumers of a queue'
      params do 
        requires :queue_id, type: String, desc: 'Queue ID.'
        requires :body, type: String, desc: 'message body (text)'
      end
      post ':queue_id/messages' do
        queue = CustomQueue.find(params[:queue_id])
        queue.consumers.each do |consumer|
          # send message to callback url with body & timestamps
        end
      end


      ### Consume Messages

      # POST /queues/:id/consumers
      desc 'Registers a new consumer to a queue.'
      params do 
        requires :queue_id, type: String, desc: 'Queue ID.'
        requires :callback_url, type: String, desc: 'URL for receiving messages.'
      end

      # GET /queues/:id/consumers
      desc 'Return the list of consumers for a queue'
      params do 
        requires :queue_id, type: String, desc: 'Queue ID.'
      end
      get ':queue_id/consumers' do
        queue = CustomQueue.find(params[:queue_id])
        queue.consumers.all
      end

      # DELETE /queues/:id/consumers/:consumer_id
      desc 'Delete an existing consumer.'
      params do
        requires :queue_id, type: String, desc: 'Queue ID.'
        requires :consumer_id, type: String, desc: 'Consumer ID.'
      end
      delete ':queue_id/consumers/:consumer_id' do
        queue = CustomQueue.find(params[:queue_id])
        queue.find_by_id(params[:consumer_id])
      end
    end


  end
end

