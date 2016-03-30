FactoryGirl.define do
  factory :event do
    name Faker::Beer.name
  end

  factory :event_with_times, class: Event do
    name "some gathering"

    after(:create) do |event|
      3.times do |i|
        create(:event_time, event: event, event_time: Faker::Time.forward(i, :morning))
      end
    end
  end

  factory :event_with_all, class: Event do
    name "others gathering"

    after(:create) do |event|
      3.times do |i|
        create(:event_time_with_people, event: event, event_time: Faker::Time.forward(i, :morning))
      end
    end
  end
end
