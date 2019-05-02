class BoardgamesController < ApplicationController
  
  get '/boardgames' do
    if logged_in?
      @boardgames = Boardgame.all.uniq
      erb :'/boardgames/index' 
    else
      redirect '/login'
    end

  end

  get '/boardgames/new' do
    if logged_in?
      erb :'/boardgames/new'
    else
      redirect '/login'
    end
  end

  post '/boardgames' do 
    if params[:boardgame]["name"].empty?
      redirect '/boardgames/new'
    else
      Boardgame.all.each do |boardgame|
        if boardgame.name == params[:boardgame]["name"]
          redirect '/boardgames/new'
        end
      end
        
      @boardgame = Boardgame.create(params[:boardgame])
      current_user.boardgames << @boardgame
      @boardgame.save
      redirect to "boardgames/#{@boardgame.id}"
    end
  end
  
  get '/boardgames/:id/add' do
    @boardgame = Boardgame.find_by_id(params[:id])
    current_user.boardgames << @boardgame
    redirect "/boardgames/#{@boardgame.id}"
  end

  get '/boardgames/:id' do
    @boardgame = Boardgame.find(params[:id])
    @users = User.all
    erb :'/boardgames/show'
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
    @boardgame = Boardgame.find(params[:id])
    erb :'/boardgames/edit'
  end
  
end