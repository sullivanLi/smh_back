class EventPersonTime < ActiveRecord::Base
  belongs_to :time, class_name: "EventTime"
  belongs_to :person
end
