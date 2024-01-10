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


end
