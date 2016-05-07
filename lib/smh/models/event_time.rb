class EventTime < ActiveRecord::Base
  belongs_to :event
  has_many :event_person_times
  has_many :people, through: :event_person_times

  validates_uniqueness_of :event_time, scope: :event_id

  alias_attribute :time, :event_time

  def time_str
    time.strftime("%Y/%m/%d %H:%M")
  end
end
