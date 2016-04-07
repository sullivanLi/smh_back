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
      event_time = Time.now.strftime("%Y/%m/%d %H:%M")
      post "/event/#{event.id}/time", {time: event_time}

      assert_equal 200, last_response.status
      assert_equal event_time, event.times.first.event_time.strftime("%Y/%m/%d %H:%M")
    end
  end

  def test_add_existing_time_to_event
    event = create(:event)
    event_time = Time.now.strftime("%Y/%m/%d %H:%M")
    event.times.create(event_time: event_time)
    post "/event/#{event.id}/time", {time: event_time}
    
    assert_equal 422, last_response.status
    assert_equal 1, event.times.count
  end

  def test_add_time_to_event_with_person
  end

  def test_remove_time_from_event_with_person
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
