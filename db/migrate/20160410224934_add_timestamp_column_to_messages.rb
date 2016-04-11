class AddTimestampColumnToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :timestamp, :integer
  end
end
