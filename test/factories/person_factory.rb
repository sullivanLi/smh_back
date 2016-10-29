FactoryGirl.define do
  factory :person do
    name Faker::Name.name
    sequence(:fb_id) { |n| "#{Faker::Number.number(10)}#{n}" }
  end
end
