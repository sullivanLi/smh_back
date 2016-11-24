require './config/environment'

class EventAPI < Sinatra::Base
  before do
    content_type :json
    response.headers["Access-Control-Allow-Origin"] = "*"
    if request.request_method == 'OPTIONS'
      response.headers["Access-Control-Allow-Methods"] = "POST, PUT, DELETE"
      halt 200
    end
  end

  post '/people/fb' do
    fb_id = params['fb_id']
    name = params['name']
    puts name
    puts fb_id
    if fb_id.present? && name.present?
      person = Person.find_or_initialize_by(fb_id: fb_id)
      person.name = name
      person.save
      status 200
      { :id => person.id }.to_json
    else
      status 404
    end
  end

  post '/events' do
    name = params['name']
    desc = params['description']
    dates = params['dates']
    person = Person.find_by(fb_id: params['fb_id'])
    if person.nil?
      status 401
      { :error => 'user is invalid.' }.to_json
    elsif name.present? && desc.present?
      event = Event.create(name: name, description: desc, owner: person)
      if dates.present?
        dates = dates.split(',')
        dates.each do |date|
          time = event.times.new(event_time: date.to_datetime)
          time.save if time.valid?
        end
      end
      status 200
      { :id => event.id }.to_json
    end
  end

  put '/events/:id' do
    name = params['name']
    desc = params['description']
    dates = params['dates']
    person = Person.find_by(fb_id: params['fb_id'])
    event = Event.find_by(id: params['id'])
    if event.nil?
      status 404
      { :error => 'event is not existing.' }.to_json
    elsif person.nil?
      status 401
      { :error => 'user is invalid.' }.to_json
    elsif event.owner.fb_id != person.fb_id
      status 403
      { :error => 'user is not the owner.' }.to_json
    elsif name.present? && desc.present?
      event.update(name: name, description: desc)
      if dates.present?
        dates = dates.split(',')
        dates.each do |date|
          time = event.times.new(event_time: date.to_datetime)
          time.save if time.valid?
        end
        dates.map!{ |date| date.to_datetime}
        event.times.where.not(event_time: dates).destroy_all
      end
      status 200
      { :id => event.id }.to_json
    end
  end

  post '/events/:id/times' do
    event = Event.find(params['id'])
    if params['time'].present?
      time = event.times.new(event_time: params['time'].to_datetime)
      if time.valid?
        time.save
      else
        status 422
        body time.errors.messages.to_s
      end
    end
  end
  
  post '/times/:id/person' do
    event_time = EventTime.find_by(id: params['id'])
    person = Person.find_by(fb_id: params['fb_id'])
    if event_time.present? && person.present?
      event_person_time = EventPersonTime.find_or_create_by(event_time_id: event_time.id, person_id: person.id)
    end
  end

  delete '/events/:id' do
    event = Event.find_by(id: params[:id])
    person = Person.find_by(fb_id: params[:fb_id])
    if person.present? && event.present?
      if event.owner.id == person.id
        event.delete
      elsif
        status 403
      end
    elsif
      status 404
    end
  end

  delete '/times/:id/person' do
    event_time = EventTime.find_by(id: params['id'])
    person = Person.find_by(fb_id: params['fb_id'])
    if event_time.present? && person.present?
      event_person_time = EventPersonTime.find_by(event_time_id: event_time.id, person_id: person.id)
      event_person_time.delete if event_person_time.present?
    end
  end

  get '/events/:id' do
    @event = Event.find_by(id: params['id'])
    if @event.present?
      Rabl::Renderer.json(@event, 'event_summary')
    else
      status 404
    end
  end

  get '/events' do
    person = Person.find_by(fb_id: params['fb_id'])
    @events = []
    if person.present?
      @events = person.events
    end
    Rabl::Renderer.json(@events, 'event_list')
  end

  get '/events/:id/people/:person_id' do
    event = Event.find(params['id'])
    person = Person.find(params['person_id'])
    if event.present? && person.present?
      @times = EventTime.includes(:event, :people).where(event_id: event.id, people: {id: person.id})
      Rabl::Renderer.json(@times, 'event_personal_summary')
    end
  end

  get '/events/:id/times/:event_time_id' do
    @event_time = EventTime.find_by(id: params['event_time_id'], event_id: params['id'])
    Rabl::Renderer.json(@event_time, 'event_time_summary')
  end
end
