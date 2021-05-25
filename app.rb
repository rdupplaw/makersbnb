# frozen_string_literal: true

require 'sinatra/base'
require 'pg'
require './lib/user'
require_relative './lib/listing'
require_relative './lib/booking'

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

  get '/listings/:id' do
    @listing = Listing.find(id: params[:id])
    erb(:'listings/profile')
  end

  post '/listings/:id/bookings' do
    Booking.create(start_date: params[:start_date], listing_id: params[:id], user_id: session[:user_id])
    redirect('/bookings')
  end

  get '/bookings' do
  end

  # start the server if ruby file executed directly
  run! if app_file == $PROGRAM_NAME
end
