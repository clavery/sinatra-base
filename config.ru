require 'rubygems'
require 'bundler'
require 'sequel'
require 'sinatra/base'
require 'sinatra/reloader'
require 'rack/flash'
require 'logger'
require 'bcrypt'
require 'json'
require 'securerandom'

# set DATABASE_URL in production at least - ie in thin
Sequel.connect ENV['DATABASE_URL'] ? ENV['DATABASE_URL'] : 'sqlite://database.db'

require './app'
require './auth'
require './models'

use Rack::Static, {:urls => %w{/public} }
use Rack::Session::Cookie,
  :secret => SecureRandom::base64, # restarts will invalidate cookies
  :expire_after => 60*60*24*30 # 30 days
use Rack::MethodOverride
use Rack::Flash, :accessorize => [:error, :success, :notice], :sweep => true

use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = Auth
end

map "/app" do
  run App
end

map "/auth" do
  run Auth
end

