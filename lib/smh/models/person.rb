class Person < ActiveRecord::Base
	has_many :event_person_times
	has_many :event_times, through: :event_person_times
end
