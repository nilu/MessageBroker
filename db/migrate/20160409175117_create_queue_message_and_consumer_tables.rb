class CreateQueueMessageAndConsumerTables < ActiveRecord::Migration
  def change
    create_table :queues do |t|
      t.string :name
    end

    create_table :messages do |t|
      t.integer :queue_id
      t.string :body
    end

    create_table :consumers do |t|
      t.integer :queue_id
      t.string :callback_url
    end
  end
end
