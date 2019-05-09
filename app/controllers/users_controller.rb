class UsersController < ApplicationController

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end
  
  get '/signup' do
    if !logged_in?
      erb :'/users/create_users', :layout => :layout_nouser
    else
      redirect '/boardgames'
    end
  end

  post '/signup' do
    if !params[:password].empty? && !params[:username].empty? && !params[:email].empty?
      
      if User.find_by(:username => params[:username])
        redirect '/signup'
      end
      
      @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
      if @user.save
        session[:user_id] = @user.id
        redirect "/users/#{@user.slug}"
      else
        redirect '/signup'
      end
    else
      redirect '/signup'
    end
  end

  get '/login' do
    if !logged_in?
      erb :'/users/login', :layout => :layout_nouser
    else
      redirect '/boardgames'
    end
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/users/#{user.slug}"
    else
      redirect '/login'
    end
  end

  get '/logout' do
    if logged_in?
      session.destroy
    end
    redirect '/login'
  end

end
