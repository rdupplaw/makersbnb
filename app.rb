# frozen_string_literal: true

require 'sinatra/base'
require 'pg'
require './lib/user'
require_relative './lib/listing'

# Controller for web application
class App < Sinatra::Base
  enable :sessions

  get '/' do
    redirect('/listings')
  end
  
  get '/listings' do
    @email = session[:email]
    @listings = Listing.all
    erb :'listings/index'
  end

  get '/users/new' do
    erb(:'users/new')
  end

  post '/users' do
    User.register(email: params['email'], password: params['password'])
    session[:email] = params['email']
    redirect('/listings')
  end

  get '/bookings/:id' do
    @listing = Listing.find(id: params[:id])
    erb(:'listings/bookings')
  end

  post '/bookings' do
    @date = params['date']
    Booking.create(@date)
    redirect('/bookings')
  end
  
  # start the server if ruby file executed directly
  run! if app_file == $PROGRAM_NAME
end
