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

  delete '/event/:id/person' do
    event = Event.find(params['id'])
    if params['time'].present? && params['person_name'].present?
      event_time = EventTime.find_by("strftime('%Y/%m/%d %H:%M', event_time) = ? and event_id = ?", params['time'], event.id)
      person = Person.find_by(name: params['person_name'])
      if event_time.present? && person.present?
        event_person_time = EventPersonTime.find_by(event_time_id: event_time.id, person_id: person.id)
        event_person_time.delete if event_person_time.present?
      end
    end
  end

  get '/event/:id' do
    @event = Event.find(params['id'])
    Rabl::Renderer.json(@event, 'event_summary')
  end

  get '/event/:id/person/:person_id' do
    event = Event.find(params['id'])
    person = Person.find(params['person_id'])
    if event.present? && person.present?
      @times = EventTime.includes(:event, :people).where(event_id: event.id, people: {id: person.id})
      Rabl::Renderer.json(@times, 'event_personal_summary')
    end
  end

  get '/event/:id/time/:event_time_id' do
    @event_time = EventTime.find_by(id: params['event_time_id'], event_id: params['id'])
    Rabl::Renderer.json(@event_time, 'event_time_summary')
  end
end
