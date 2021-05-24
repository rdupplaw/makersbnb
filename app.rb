require 'sinatra/base'
require 'pg'
require './lib/user'

class App < Sinatra::Base
  enable :sessions

  get '/' do
    redirect('/listings')
  end

  get '/listings' do
    @email = session[:email]
    erb(:'listings/index')
  end

  get '/users/new' do
    erb(:'users/new')
  end

  post '/users' do
    User.register(email: params['email'], password: params['password'])
    session[:email] = params['email']
    redirect('/listings')
  end
  # start the server if ruby file executed directly
  run! if app_file == $0
end
