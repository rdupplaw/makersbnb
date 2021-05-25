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
    if session[:user_id]
      @user = User.find(session[:user_id])
    end
    @listings = Listing.all
    erb :'listings/index'
  end

  get '/listings/new' do
    erb :'listings/new'
  end

  post '/listings' do
    Listing.create(name: params[:name], description: params[:description], price: params[:price] )
    redirect '/listings' 
  end

  get '/users/new' do
    erb(:'users/new')
  end

  post '/users' do
    user = User.register(email: params['email'], password: params['password'])
    session[:user_id] = user.id 
    redirect('/listings')
  end

  post '/sessions/destroy' do
    session.clear
    redirect('/listings')
  end
  
  # start the server if ruby file executed directly
  run! if app_file == $PROGRAM_NAME
end
