class EventTime < ActiveRecord::Base
  belongs_to :event
  has_many :event_person_times
  has_many :people, through: :event_person_times

  validates_uniqueness_of :event_time, scope: :event_id
  
  def people_count
    people.count
  end
end
