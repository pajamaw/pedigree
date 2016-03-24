class UserController < ApplicationController


  get "/users/signup" do 
    if !logged_in?
      erb :'users/signup'
    else
      redirect "/"
    end
  end

  post "/users/signup" do
    user = User.new(username: params[:username], password: params[:password], password_confirmation: params[:password_confirmation], email: params[:email], family_name: params[:family_name])
    if !user.valid?
      redirect "/users/signup", locals: {message: "Please do not leave any fields blank."}
    else 
      user.save
      session[:id] = user.id
      redirect "/users/account" 
    end
  end

  get "/users/login" do
    if !logged_in? 
      erb :'users/login'
    else 
      redirect "/users/account"
    end
  end

  post "/users/login" do
    if params[:username].empty? || params[:password].empty?
      redirect "/users/login"
    else
      user = User.find_by(username: params[:username])
      if user && user.authenticate(params[:password])
        session[:id] = user.id
        redirect "/users/account" 
      else
        redirect "/"
      end
    end
  end

  get '/users/account' do 
    erb :'users/account'
  end

  get "/users/logout" do
    session.clear
    redirect "/"
  end

  get '/users/failure' do 
    erb :'users/failure'
  end

end