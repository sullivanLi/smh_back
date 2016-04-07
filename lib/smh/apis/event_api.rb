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

  get '/event/:id' do
    @event = Event.find(params['id'])
    Rabl::Renderer.json(@event, 'event_summary')
  end
end
