ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'json'
require './config/environment'

module WithRollback
  def temporarily(&block)
    ActiveRecord::Base.connection.transaction do
      block.call
      raise ActiveRecord::Rollback
    end
  end
end

class Minitest::Unit::TestCase
  include Rack::Test::Methods
  include FactoryGirl::Syntax::Methods
  include WithRollback
end

FactoryGirl.find_definitions
