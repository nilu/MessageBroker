class Consumer < ActiveRecord::Base
  belongs_to :custom_queue

  include HTTParty # For sending http request to consumer

  def send_message(timestamp, message, message_id)
    begin
      puts "Sending Message to..."
      puts "callbackurl: #{self.callback_url}"
      @result = HTTParty.post(self.callback_url,
        body: {
          id: message_id,
          timestamp: timestamp,
          message: message,
        }.to_json,
        :headers => {'Content-Type' => 'application/json'}
      )
    rescue Net::ReadTimeout
      # Since Rails doesn't support multithreading, this will lock
      # the app since since it can't reach consumer. Very Bad!
      puts 'retrying...'
      retry 
    rescue Exception => e
      puts e
    end
  end
end
