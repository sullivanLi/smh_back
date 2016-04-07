require './config/environment'

class EventAPI < Sinatra::Base
  post '/event' do
    Event.create(name: params['name']) if params['name'].present?
  end

  post '/event/:id/time' do
    @event = Event.find(params['id'])
    if params['time'].present?
      event_time = params['time']
      @event.times.create(event_time: event_time.to_datetime)
    end
  end

  get '/event/:id' do
    @event = Event.find(params['id'])
    Rabl::Renderer.json(@event, 'event_summary')
  end
end
