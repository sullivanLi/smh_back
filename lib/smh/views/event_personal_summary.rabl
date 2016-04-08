object false
node(:event_id) { @object.first.event_id }
node(:person_id) { @object.first.people.first.id }
node(:available_times_count) { @object.count }
node :available_times do
  @object.map(&:event_time).map{|t| t.strftime("%Y/%m/%d %H:%M")}
end
