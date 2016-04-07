require './config/environment'

class EventAPI < Sinatra::Base
  post '/event' do
    Event.create(name: params['name']) if params['name'].present?
  end

  post '/event/:id/time' do
    event = Event.find(params['id'])
    if params['time'].present?
      time = event.times.new(event_time: params['time'].to_datetime)
      if time.valid?
        time.save
      else
        status 422
        body time.errors.messages
      end
    end
  end
  
  post '/event/:id/person' do
    event = Event.find(params['id'])
    if params['time'].present? && params['person_name'].present?
      event_time = EventTime.find_or_create_by(event_id: event.id, event_time: params['time'].to_datetime)
      person = Person.find_or_create_by(name: params['person_name'])
      event_person_time = EventPersonTime.find_or_create_by(event_time_id: event_time.id, person_id: person.id)
    end
  end

  get '/event/:id' do
    @event = Event.find(params['id'])
    Rabl::Renderer.json(@event, 'event_summary')
  end
end
