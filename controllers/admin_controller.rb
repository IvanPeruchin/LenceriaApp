# frozen_string_literal: true

# AdminController es el responzable de menu, de lenceria, de deportivos y de modificaciones
class AdminController < Sinatra::Application
  before do
    redirect '/' if session[:user_id].nil? && request.path_info != '/'
    @user = User.current_user(:id, session[:user_id]) unless session[:user_id].nil?
  end

  get '/menu' do
    session[:tree] = false
    user_id = session[:user_id]
    erb :menu, locals: { user_id: user_id }
  end

  get '/deportivo' do
    erb :deportivo
  end

  get '/lenceria' do 
    erb :lenceria
  end
  
  get '/profile' do
    @verificated = @user.valid_email
    erb :profile
  end

  get '/profile_change' do
    erb :profile_change
  end

  post '/profile_change' do
    new_username = params[:new_username]
    current_password = params[:current_password]
    new_password = params[:new_password]
    new_email = params[:new_email]

    if (new_username != '' && !User.find_by(username: new_username).nil?) ||
       (new_password != '' && !current_password.nil? && (current_password != @user.password)) ||
       (new_email != '' && !User.find_by(email: new_email).nil?)
      redirect '/profile_change'
    end

    @user.update_column(:username, new_username) if new_username != ''

    @user.update_column(:password, new_password) if new_password != '' && current_password != ''

    @user.update_column(:email, new_email) if new_email != ''

    redirect '/menu' unless @user.save

    redirect '/profile'
  end

end
