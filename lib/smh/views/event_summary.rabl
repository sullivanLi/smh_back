object @event
attributes :id, :name, :description
child @event.times => 'times' do
  attributes :id, :time
  child :people do
    attributes :id, :name
  end
end
