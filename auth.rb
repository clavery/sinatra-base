# Sinatra app for authentication

require 'rubygems'
require 'sinatra/base'
require 'sequel'
require 'bcrypt'
require 'warden'
require 'logger'

# set DATABASE_URL in production at least
Sequel.connect ENV['DATABASE_URL'] ? ENV['DATABASE_URL'] : 'sqlite://passman.db'

require './models'

# serialize to and from session so we can get user model in views
Warden::Manager.serialize_into_session do |user|
  user.nil? ? nil : user.id
end

Warden::Manager.serialize_from_session do |id| 
  id.nil? ? nil : (User.first :id => id)
end

# Add a password strategy that delegates to a user model
Warden::Strategies.add(:password) do
  def valid?
    params["username"] || params["password"]
  end

  def authenticate!
    u = User.authenticate(params["username"], params["password"])
    u.nil? ? fail!("Could not log in") : success!(u)
  end
end

class Auth < Sinatra::Base
  disable :run
  # logging for auditing
  enable :logging
  # views directory
  set :views, 'auth_views'

  configure :development do
    # code reloading
    register Sinatra::Reloader
  end

  configure :production do
  end

  before do
    # if redirect_to is in session make it available to views
    @redirect_to = env['rack.session']['redirect_to'] ? env['rack.session']['redirect_to'] : nil
  end

  get '/unauthenticated' do
    status 401
    erb :login
  end
  get '/login' do
    erb :login
  end
  post '/login' do
    if env['warden'].authenticate(:password)
      logger.info "Success login '#{params[:username]}' - #{env['REMOTE_ADDR']}"
      if env['rack.session']['redirect_to']
        redirect env['rack.session']['redirect_to']
      else
        redirect "/"
      end
    else
      flash[:error] = "Invalid login"
      logger.warn "Invalid login '#{params[:username]}' - #{env['REMOTE_ADDR']}"
      erb :login
    end
  end
  get '/logout' do
    env['warden'].logout
    redirect '/login'
  end
end
