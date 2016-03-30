require './test/test_helper'

class PersonTest < MiniTest::Unit::TestCase
	include WithRollback

	def test_it_exists
		temporarily do
			person = Person.create(:name => 'test_sullivan')
			assert_equal true, Person.find_by_name('test_sullivan').present?
		end
	end
end
