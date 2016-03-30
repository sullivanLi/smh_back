FactoryGirl.define do
  factory :event_person_time do
    after(:create) do |ept|
      ept.person = create(:person, name: Faker::Name.name)
    end
  end
end
