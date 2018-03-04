class RsvpsController < ApplicationController

  helper_method :is_user_invited_to_event
  
  def index
    @rsvps = Rsvp.get_confirmed_rsvps_by_user(current_user.id)
  end

  def add
    @event = Event.find_by(id: params[:event_id])
    @rsvps = Rsvp.includes(:user).find_by(event_id: params[:event_id])

    if params[:search]
      #clean up whitespace, split on space or comma to allow for multiple names, search on each term
      search = params[:search].strip
      search_terms= search.split(/[\s,]+/)
      search_results = []
      search_terms.each do |term|
        search_results += User.search_by_name(term)
      end
      @users = search_results.uniq
    else
      @users = User.all.limit(50)
    end
    
    if request.post?
      Rsvp.create(event_id: params[:event_id], user_id: params[:user_id])
    end
  end

  def confirm
    #Find existing RSVP, if none exists, create new
    @event = Event.find_by(id: params[:event_id])
    @rsvp = if Rsvp.find_by(event_id: params[:event_id], user_id: @current_user.id).present?
      Rsvp.find_by(event_id: params[:event_id], user_id: @current_user.id)
    else
      Rsvp.new(event_id: params[:event_id], user_id: @current_user.id)
    end

    if request.post?
      #if event is public and rsvp is 'no' then delete rsvp record, else save rsvp after validation
      if @event.event_type == 'public' and rsvp_params["rsvp_status"] == 'no'
        @rsvp.destroy
        redirect_to events_index_path
      else
        @rsvp.rsvp_status = rsvp_params["rsvp_status"]
        @rsvp.guests = rsvp_params["guests"]
        if @rsvp.save
          redirect_to events_index_path
        else
          flash[:error] = @rsvp.errors.full_messages.map { |v| v }.join('<br/>')
          redirect_to rsvps_confirm_path
        end
      end
    end
  end

  def export    
    respond_to do |format|
      format.html
      format.csv {send_data Rsvp.to_rsvp_list_csv(params[:event_id]), filename: "rsvp-list-#{params[:event_id]}.csv"}
    end
  end

  def is_user_invited_to_event(eventId,userId)
    if Rsvp.find_by(event_id: eventId, user_id: userId).present?
      return true
    else
      return false
    end
  end

  def rsvp_params
    params.require(:rsvp).permit(:rsvp_status, :guests)
  end

end
