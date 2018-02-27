class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authorize, :except => [:welcome]

  def current_user
    if session[:account_type]
      @account_type = session[:account_type]
      if session[:account_type] == 'user'
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
      else
        @current_host ||= Host.find(session[:host_id]) if session[:host_id]
      end
    end
  end

  def authorize
    redirect_to application_welcome_path unless current_user
  end

  def only_host_action
    redirect_to events_index_path unless session[:account_type] == 'host'
  end

  def welcome

  end
end
