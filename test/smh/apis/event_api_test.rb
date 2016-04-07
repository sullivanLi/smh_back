require './test/test_helper'

class APITest < MiniTest::Unit::TestCase
  def app
    EventAPI
  end

  def test_create_event
    temporarily do
      post '/event', {name: 'test_event'}

      assert_equal 200, last_response.status
      assert_equal true, Event.find_by_name('test_event').present?
    end
  end

  def test_add_time_to_event
    temporarily do
      event = create(:event)
      time = Time.now.strftime("%Y/%m/%d %H:%M")
      post "/event/#{event.id}/time", {time: time}
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
      post "/event/#{event.id}/time", {time: event_time}

      assert_equal 422, last_response.status
      assert_equal 1, event.times.count
    end
  end

  def test_add_time_to_event_with_person
    temporarily do
      event = create(:event)
      name = Faker::Name.name
      time = Time.now.strftime("%Y/%m/%d %H:%M")
      post "/event/#{event.id}/person", {time: time, person_name: name}
      event_time = EventTime.find_by("strftime('%Y/%m/%d %H:%M', event_time) = ? and event_id = ?", time, event.id)
      person = Person.find_by(name: name)

      assert_equal 200, last_response.status
      assert_includes event.times, event_time
      assert_includes event_time.people, person
    end
  end

  def test_remove_time_from_event_with_person
    temporarily do
      event = create(:event_with_all)
      eventTime = event.times.sample
      person = eventTime.people.sample
      event_time = eventTime.event_time.strftime("%Y/%m/%d %H:%M")
      name = person.name
      delete "/event/#{event.id}/person", {time: event_time, person_name: name}
      eventTime.reload

      assert_equal 200, last_response.status
      refute_includes eventTime.people, person 
    end
  end

  def test_get_event_times_summary
    temporarily do
      event = create(:event_with_all)
      get "/event/#{event.id}"

      data = JSON.parse last_response.body
      assert_equal 200, last_response.status
      assert_equal event.id, data['event_id']
      assert data['event_times_count']
      assert data['event_times']
      assert data['event_times'].kind_of?(Array)
      assert data['event_times'].first['event_time']['people_count']
      assert data['event_times'].first['event_time']['people']
      assert data['event_times'].first['event_time']['people'].kind_of?(Array)
      assert data['event_times'].first['event_time']['people'].first['person']
      assert data['event_times'].first['event_time']['people'].first['person']['name']
    end
  end

  def test_get_personal_times_summary
  end

  def test_specific_time_summary
  end
end
