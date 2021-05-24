require 'sinatra/base'
require 'pg'
require './lib/user'

class App < Sinatra::Base
  get '/' do
    redirect('/listings')
  end

  get '/listings' do
    'erb(:listings)'
  end

  get '/users/register' do
    erb(:'users/register')
  end

  post '/users/new' do
    User.register(email: params['email'], password: params['password'])
    redirect('/listings')
  end
  # start the server if ruby file executed directly
  run! if app_file == $0
end
