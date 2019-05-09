class BoardgamesController < ApplicationController
  
  get '/boardgames' do
    redirect_if_not_logged_in
    @boardgames = Boardgame.all.uniq{ |bg| bg.name }
    erb :'/boardgames/index' 
  end

  get '/boardgames/new' do
    redirect_if_not_logged_in
    erb :'/boardgames/new'
  end

  post '/boardgames' do 
    if params[:boardgame]["name"].empty?
      redirect '/boardgames/new'
    else
      @boardgame = current_user.boardgames.create(params[:boardgame])
      redirect to "boardgames/#{@boardgame.id}"
    end
  end

  get '/boardgames/:id' do
    redirect_if_not_logged_in
    @boardgame = Boardgame.find(params[:id])
    @user = User.find_by(id: @boardgame.user_id)
    erb :'/boardgames/show'
  end

  patch '/boardgames/:id' do 
    if params[:boardgame]["name"].empty?
      redirect "/boardgames/#{params[:id]}/edit"
    end
    
    redirect_if_not_logged_in
    @boardgame = Boardgame.find_by_id(params[:id])
    redirect_if_not_authorized(@boardgame)
    if @boardgame.update(params[:boardgame])
      redirect "/boardgames/#{@boardgame.id}"
    else
      redirect "/boardgames/#{@boardgame.id}/edit"
    end
  end

  get '/boardgames/:id/edit' do
    redirect_if_not_logged_in 
    @boardgame = Boardgame.find(params[:id])
    if current_user.id == @boardgame.user_id
      erb :'/boardgames/edit'
    else
      redirect '/boardgames'
    end
  end
  
  delete '/boardgames/:id' do
    redirect_if_not_logged_in
    @boardgame = Boardgame.find_by_id(params[:id])
    if current_user.id == @boardgame.user_id
      @boardgame.delete
      redirect '/boardgames'
    else
      redirect "/boardgames/#{@boardgame.id}"
    end
  end
  
end
