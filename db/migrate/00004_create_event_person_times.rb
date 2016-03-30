class CreateEventPersonTimes < ActiveRecord::Migration
	def change
		create_table :event_person_times do |t|
			t.belongs_to :event_time
			t.belongs_to :person
			t.timestamps
		end

    add_index :event_person_times, [:event_time_id, :person_id], unique: true
	end
end
