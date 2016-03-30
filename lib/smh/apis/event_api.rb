require './config/environment'

class EventAPI < Sinatra::Base
  post '/event' do
		Event.create(name: params['name']) if params['name'].present?
	end

	get '/event/:id' do
		@event = Event.find(params['id'])
    Rabl::Renderer.json(@event, 'event_summary')
	end
end
