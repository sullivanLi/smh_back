class Event < ActiveRecord::Base
  has_many :times, class_name: "EventTime"
end
