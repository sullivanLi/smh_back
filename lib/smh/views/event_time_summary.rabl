object false
node(:event_id) { @object.event_id }
node(:event_time_id) { @object.id }
node(:available_people_count) { @object.people.count }
node :available_people do
  @object.people.map(&:name)
end
