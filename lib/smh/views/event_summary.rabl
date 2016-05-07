object @event
attributes :id, :name, :description
child @event.times => 'times' do
  attributes :id, :date_str
  child :people do
    attributes :id, :name
  end
end
