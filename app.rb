# frozen_string_literal: true

require 'sinatra/base'
require 'pg'
require 'sinatra/flash'
require './lib/user'
require_relative './lib/listing'
require_relative './lib/booking'
require_relative './database_connection_setup'

# Controller for web application

class App < Sinatra::Base
  enable :sessions
  register Sinatra::Flash
  use Rack::MethodOverride

  get '/' do
    redirect('/listings')
  end

  get '/listings' do
    @user = User.find(session[:user_id]) if session[:user_id]
    @listings = Listing.all
    erb :'listings/index', layout: :layout
  end

  get '/listings/new' do
    erb :'listings/new'
  end

  post '/listings' do
    Listing.create(name: params[:name], description: params[:description], price: params[:price],
                   owner_id: session[:user_id])
    redirect '/listings'
  end

  get '/users/new' do
    erb(:'users/new')
  end

  get '/sessions/new' do
    erb(:'sessions/new')
  end

  post '/users' do
    user = User.register(email: params['email'], password: params['password'])
    session[:user_id] = user.id
    redirect('/listings')
  end

  get '/listings/:id' do
    @listing = Listing.find(id: params[:id])
    erb(:'listings/profile')
  end

  post '/listings/:id/bookings' do
    if Booking.exists(start_date: params[:start_date], listing_id: params[:id])
      flash[:notice] = 'A booking already exists on this date'
      redirect("/listings/#{params[:id]}")
    else
      Booking.create(start_date: params[:start_date], listing_id: params[:id], user_id: session[:user_id])
      redirect('/bookings')
    end
  end

  get '/bookings' do
    @outgoing_bookings = Booking.where(user_id: session[:user_id])
    @incoming_bookings = Booking.incoming_bookings(owner_id: session[:user_id])
    erb :'bookings/index'
  end

  get '/bookings/:id' do
    @booking = Booking.find_by_id(id: params[:id])
    @incoming_bookings = Booking.incoming_bookings(owner_id: session[:user_id])
    @listing = Listing.find(id: @booking.listing_id)
    @user = User.find(@booking.user_id)
    erb(:'bookings/profile')
  end

  patch '/bookings/:id' do
    booking = Booking.find_by_id(id: params[:id])
    params[:choice] == 'accept' ? booking.accept : booking.reject
    redirect('/bookings')
  end

  post '/sessions' do
    user = User.login(params['email'], params['password'])
    session[:user_id] = user.id if user
    redirect('/listings')
  end

  post '/sessions/destroy' do
    session.clear
    redirect('/listings')
  end

  # start the server if ruby file executed directly
  run! if app_file == $PROGRAM_NAME
end
