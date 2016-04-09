class ChangeQueueTableNameToCustomQueues < ActiveRecord::Migration
  def self.up
    rename_table :queues, :custom_queues
  end 
  
  def self.down
    rename_table :custom_queues, :queues
  end
end
