# Example App

module Sinatra::Helpers
  # allow django-like sections
  def section(key, *args, &block)
    @sections ||= Hash.new{ |k,v| k[v] = [] }
    if block_given?
      @sections[key] << block
    else
      @sections[key].inject(''){ |content, block| content << block.call(*args) } if @sections.keys.include?(key)
    end
  end
end

class App < Sinatra::Base
  # logging for application auditing
  enable :logging
  enable :sessions

  helpers do
    def user
      env['warden'].user
    end
  end

  configure :development do
    # code reloading
    register Sinatra::Reloader
  end

  configure :production do
  end

  #### ROUTES ####

  not_found do
    erb :'404'
  end

  error do
    @error = env['sinatra.error'].to_json
    erb :'50x'
  end

  before do
    unless env['warden'].authenticated?
      session['redirect_to'] = to('/')
      env['warden'].authenticate!(:password)
    end
  end

  # index page
  get '/' do
    @foobars = Foobar.all
    logger.warn "Oh crap test logging!"
    erb :index
  end
end
