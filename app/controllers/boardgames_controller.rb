class BoardgamesController < ApplicationController
  
  get '/boardgames' do
    if logged_in?
      @boardgames = Boardgame.all.uniq{ |bg| bg.name }
      erb :'/boardgames/index' 
    else
      redirect '/login', :layout => :layout_nouser
    end
  end

  get '/boardgames/new' do
    if logged_in?
      erb :'/boardgames/new'
    else
      redirect '/login', :layout => :layout_nouser
    end
  end

  post '/boardgames' do 
    if params[:boardgame]["name"].empty?
      redirect '/boardgames/new'
    else
      # Boardgame.all.each do |boardgame|
      #   if boardgame.name == params[:boardgame]["name"]
      #     redirect '/boardgames/new'
      #   end
      # end
        
      @boardgame = Boardgame.create(params[:boardgame])
      current_user.boardgames << @boardgame
      @boardgame.save
      redirect to "boardgames/#{@boardgame.id}"
    end
  end

  get '/boardgames/:id' do
    if logged_in?
      @boardgame = Boardgame.find(params[:id])
      @user = User.find_by(id: @boardgame.user_id)
      erb :'/boardgames/show'
    else
      redirect '/login', :layout => :layout_nouser
    end
  end

  patch '/boardgames/:id' do 
    if params[:boardgame]["name"].empty?
      redirect "/boardgames/#{params[:id]}/edit"
    else
      @boardgame = Boardgame.find_by_id(params[:id])
      if @boardgame && current_user.id == @boardgame.user_id
        if @boardgame.update(params[:boardgame])
          @boardgame.save
          redirect "/boardgames/#{@boardgame.id}"
        else
          redirect "/boardgames/#{@boardgame.id}/edit"
        end
      end
    end
  end

  get '/boardgames/:id/edit' do
    if logged_in?
      @boardgame = Boardgame.find(params[:id])
      if current_user.id == @boardgame.user_id
        erb :'/boardgames/edit'
      else
        redirect '/boardgames'
      end
    else
      redirect '/login', :layout => :layout_nouser
    end
  end
  
  delete '/boardgames/:id' do
    if logged_in?
      @boardgame = Boardgame.find_by_id(params[:id])
      if current_user.id == @boardgame.user_id
        @boardgame.delete
        redirect '/boardgames'
      end
    else
      redirect '/login', :layout => :layout_nouser
    end
  end
  
end
