require './config/environment'

class ApplicationController < Sinatra::Base
  
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end
  
  get '/' do
    if logged_in?
      erb :'/boardgames'
    else
      redirect '/login'
    end
  end
  
  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find_by(id: session[:user_id])
    end
    
    def redirect_if_not_logged_in
      if !logged_in?
        redirect '/login'
      end
    end
    
    def redirect_if_not_authorized(boardgame)
      if !boardgame || current_user.id != boardgame.user_id
        redirect "/boardgames/#{boardgame.id}"
      end
    end
  end
  
end
