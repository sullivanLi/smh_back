require './test/test_helper'

class APITest < MiniTest::Unit::TestCase
  def app
    EventAPI
  end

  def test_create_event
    temporarily do
      dates = nil;
      3.times do |i|
        time = (Time.now + i * 86400).strftime("%Y/%m/%d %H:%M")
        if dates.nil?
          dates = time
        else
          dates = dates + ',' + time
        end
      end

      post '/events', {name: 'test_event', dates: dates, description: 'test_desc'}
      event = Event.find_by_name('test_event')

      assert_equal 200, last_response.status
      assert_equal true, event.present?
      assert_equal 3, event.times.length
      assert_equal event.description, 'test_desc'
    end
  end

  def test_user_fb_login
    temporarily do
      name = Faker::Name.name
      fb_id = Faker::Number.number(10)
      post "/people/fb", {name: name, fb_id: fb_id}
      person = Person.find_by(fb_id: fb_id)

      assert_equal 200, last_response.status
      assert_equal person.name, name
    end
  end

  def test_add_time_to_event
    temporarily do
      event = create(:event)
      time = Time.now.strftime("%Y/%m/%d %H:%M")
      post "/events/#{event.id}/times", {time: time}
      event_time = EventTime.find_by("strftime('%Y/%m/%d %H:%M', event_time) = ?", time)

      assert_equal 200, last_response.status
      assert_includes event.times, event_time
    end
  end

  def test_add_existing_time_to_event
    temporarily do
      event = create(:event)
      event_time = Time.now.strftime("%Y/%m/%d %H:%M")
      event.times.create(event_time: event_time)
      post "/events/#{event.id}/times", {time: event_time}

      assert_equal 422, last_response.status
      assert_equal 1, event.times.count
    end
  end

  def test_add_person_to_time
    temporarily do
      event = create(:event_with_all)
      eventTime = event.times.sample
      person_name = Faker::Name.name
      post "/times/#{eventTime.id}/person", {person_name: person_name}
      person = Person.find_by(name: person_name)

      assert_equal 200, last_response.status
      assert_includes eventTime.people, person
    end
  end

  def test_remove_person_from_time
    temporarily do
      event = create(:event_with_all)
      eventTime = event.times.sample
      person = eventTime.people.sample
      name = person.name
      delete "/times/#{eventTime.id}/person", {person_name: name}
      eventTime.reload

      assert_equal 200, last_response.status
      refute_includes eventTime.people, person 
    end
  end

  def test_get_event_times_summary
    temporarily do
      event = create(:event_with_all)
      get "/events/#{event.id}"

      data = JSON.parse last_response.body
      assert_equal 200, last_response.status
      assert_equal event.id, data['id']
      assert_equal event.name, data['name']
      assert_equal event.description, data['description']
      assert data['times']
      assert data['times'].kind_of?(Array)
      assert data['times'].first['id']
      assert data['times'].first['date_str']
      assert data['times'].first['people']
      assert data['times'].first['people'].kind_of?(Array)
      assert data['times'].first['people'].first['id']
      assert data['times'].first['people'].first['name']
    end
  end

  def test_get_personal_times_summary
    temporarily do
      event = create(:event_with_all)
      person = event.times.sample.people.sample
      get "/events/#{event.id}/people/#{person.id}"

      data = JSON.parse last_response.body
      assert_equal 200, last_response.status
      assert_equal event.id, data['event_id']
      assert_equal person.id, data['person_id']
      assert data['available_times_count']
      assert data['available_times']
      assert data['available_times'].kind_of?(Array)
    end
  end

  def test_specific_time_summary
    temporarily do
      event = create(:event_with_all)
      event_time = event.times.sample
      get "/events/#{event.id}/times/#{event_time.id}"

      data = JSON.parse last_response.body
      assert_equal 200, last_response.status
      assert_equal event.id, data['event_id']
      assert_equal event_time.id, data['event_time_id']
      assert data['available_people_count']
      assert data['available_people']
      assert data['available_people'].kind_of?(Array)
    end
  end
end
