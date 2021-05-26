# frozen_string_literal: true

require_relative './lib/database_connection'

if ENV['RACK_ENV'] == 'test'
  DatabaseConnection.setup('makersbnb_test')
else
  DatabaseConnection.setup('makersbnb')
end
