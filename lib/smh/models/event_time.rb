class EventTime < ActiveRecord::Base
  belongs_to :event
  has_many :event_person_times
  has_many :people, through: :event_person_times

  validates_uniqueness_of :event_time, scope: :event_id

  alias_attribute :time, :event_time

  def date_str
    dayOfWeek = ['Sun.', 'Mon.', 'Tue.', 'Wed.', 'Thu.', 'Fri.', 'Sat.']
    time.strftime("%Y/%m/%d %H:%M") + ' (' + dayOfWeek[time.wday] + ')'
  end
end
