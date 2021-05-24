# frozen_string_literal: true

require 'sinatra/base'
require_relative './lib/listing'

# Controller for web application
class App < Sinatra::Base
  get '/' do
    'Hello App!'
  end

  get '/listings' do
    @listings = Listing.all
    erb :'listings/index'
  end

  # start the server if ruby file executed directly
  run! if app_file == $PROGRAM_NAME
end
