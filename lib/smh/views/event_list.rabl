collection @events
attributes :id, :name, :description
child :times => 'times' do
  attributes :id, :date_str
  child :people do
    attributes :id, :name
  end
end
