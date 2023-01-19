require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require 'bcrypt'
require_relative 'lib/space'
require_relative 'lib/user'
require_relative 'lib/availability'
require_relative 'lib/request'

class Application < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  enable :sessions
  
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    return erb(:index)
  end

  post '/register' do
    # add user credentials to the database
    user = User.new(
      username: params[:username],
      firstname: params[:firstname],
      lastname: params[:lastname],
      email: params[:email],
      password: params[:password]
    )
    # add user to db
    user.save ? (redirect "/") : "Failed to add user!"
  end

  get '/login' do
    erb(:login)
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:session_id] = user.id
      redirect '/spaces'
    else
      erb(:login)
    end
  end

  get '/spaces' do
    redirect_if_not_logged_in
    @spaces = Space.all
    return erb(:spaces)
  end

  get '/create-space' do
    redirect_if_not_logged_in
    return erb(:create_space)
  end

  get '/requests' do
    redirect_if_not_logged_in
    @requests = [{ 'description' => 'Nice place' }, { 'description' => 'Nice place2' }]
    return erb(:requests)
  end

  post '/request' do
    user_id = session[:session_id]
    space_id = session[:space_id]
    request = Request.create(
      space_id: space_id,
      user_id: user_id,
      book_in: params[:book_in],
      book_out: params[:book_out]
    )
    redirect '/spaces'
  end

  get '/book/:id' do
    redirect_if_not_logged_in
    space_id = params[:id]
    session[:space_id] = space_id # a bit of a hack
    @space = Space.find(space_id)
    @availabilities = Availability.where("space_id = #{space_id}")
    erb(:book)
  end

  helpers do
    def logged_in?
      !!session[:session_id]
    end

    def redirect_if_not_logged_in
      redirect '/login' unless logged_in?
    end
  end
end
