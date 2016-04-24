require './config/environment'

# don’t stay open connections when requests are finished
use ActiveRecord::ConnectionAdapters::ConnectionManagement 
run EventAPI
