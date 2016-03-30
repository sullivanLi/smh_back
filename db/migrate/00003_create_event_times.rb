class CreateEventTimes < ActiveRecord::Migration
  def change
    create_table :event_times do |t|
      t.belongs_to :event
      t.time :event_time
      t.timestamps
    end

    add_index :event_times, [:event_id, :event_time], unique: true
  end
end
