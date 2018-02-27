class UsersController < ApplicationController

  skip_before_action :authorize, :only => [:register, :login]
  
  def register
    if request.post?
      @user = User.new(user_params)
      @user.evaluate_registration
      if @user.valid? && @user.save
        session[:account_type] = 'user'
        session[:user_id] = @user.id
        redirect_to events_index_path
      else
        flash[:error] = @user.errors.full_messages.map { |v| v }.join('<br/>')
        redirect_to users_register_path
      end
    else
      @user = User.new
    end
  end

  def login
    if request.post?
      user = User.find_by(email_addr: params[:email_addr], passwd: Digest::SHA256.hexdigest(params[:passwd]))
      if !user.blank?
        session[:account_type] = 'user'
        session[:user_id] = user.id
        redirect_to events_index_path
      else
        redirect_to users_login_path
      end
    end
  end

  def logout
    session[:account_type] = nil
    session[:user_id] = nil
    session[:host_id] = nil
    redirect_to application_welcome_path
  end

  def edit_profile
    if request.post?
      if @current_user.update(user_params)
        flash[:success] = 'Profile Updated'
        redirect_to users_edit_profile_path
      else
        flash[:error] = @current_user.errors.full_messages.map { |v| v }.join('<br/>')
        redirect_to users_edit_profile_path
      end
    else
      @user = @current_user
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_addr, :registration_password, :registration_password_repeat, :first_name, :last_name, :phone, :addr1, :addr2, :city, :state, :zip)
  end

end