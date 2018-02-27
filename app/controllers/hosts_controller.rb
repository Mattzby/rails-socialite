class HostsController < ApplicationController

  skip_before_action :authorize, :only => [:register, :login]

  def register
    if request.post?
      @host = Host.new(host_params)
      @host.evaluate_registration
      if @host.valid? && @host.save
        session[:account_type] = 'host'
        session[:host_id] = @host.id
        redirect_to events_index_path
      else
        flash[:error] = @host.errors.full_messages.map { |v| v }.join('<br/>')
        redirect_to hosts_register_path
      end
    else
      @host = Host.new
    end
  end

  def login
    if request.post?
      host = Host.find_by(email_addr: params[:email_addr], passwd: Digest::SHA256.hexdigest(params[:passwd]))
      if !host.blank?
        session[:account_type] = 'host'
        session[:host_id] = host.id
        redirect_to events_index_path
      else
        redirect_to hosts_login_path
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
      if @current_host.update(host_params)
        flash[:success] = 'Profile Updated'
        redirect_to hosts_edit_profile_path
      else
        flash[:error] = @current_host.errors.full_messages.map { |v| v }.join('<br/>')
        redirect_to hosts_edit_profile_path
      end
    else
      @host = @current_host
    end
  end

  private

  def host_params
    params.require(:host).permit(:email_addr, :registration_password, :registration_password_repeat, :business_name)
  end

end