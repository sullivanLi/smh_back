require 'yaml'
require 'bundler'
Bundler.require(:default, (ENV['RACK_ENV'] || 'development').to_sym)

db_options = YAML.load(File.read('./config/database.yml'))[ENV['RACK_ENV'] || 'development']
ActiveRecord::Base.establish_connection(db_options)

# require active_model
Dir.glob(File.join(File.dirname(__FILE__), "../lib/**/*.rb")).each {|file| require file}

# rabl setting
Rabl.configure do |config|
	config.view_paths = [File.join(File.dirname(__FILE__), "../lib/smh/views/")]
end
