object false
node(:event_id) { @event.id }
node(:event_times_count) { @event.times.count }
child @event.times do
  attributes :people_count
  child :people do
    attributes :name
  end
end
