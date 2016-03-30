FactoryGirl.define do
	factory :event_time do
		event_time Faker::Time.forward(23, :morning)
	end

	factory :event_time_with_people, class: EventTime do
		event_time Faker::Time.forward(23, :morning)

		after(:create) do |et|
			et.event_person_times << create_list(:event_person_time, 3)
		end
	end
end
