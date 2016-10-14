FactoryGirl.define do
  factory :person do
    name Faker::Name.name
    fb_id Faker::Number.number(10)
  end
end
