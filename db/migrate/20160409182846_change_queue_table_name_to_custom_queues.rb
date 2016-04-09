class ChangeQueueTableNameToCustomQueues < ActiveRecord::Migration
  def self.up
    rename_table :queues, :custom_queues
    rename_column :consumers, :queue_id, :custom_queue_id
    rename_column :messages, :queue_id, :custom_queue_id
  end 
  
  def self.down
    rename_table :custom_queues, :queues
    rename_column :consumers, :custom_queue_id, :queue_id
    rename_column :messages, :custom_queue_id, :ueue_id
  end
end
