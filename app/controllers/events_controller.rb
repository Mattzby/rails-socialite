class EventsController < ApplicationController

  before_action :only_host_action, :only => [:add]

  def index
    @event_time = if params[:event_time].blank? || ['upcoming', 'past'].index(params[:event_time]).nil?
      'upcoming'
    else
      params[:event_time]
    end

    @events = if @account_type == 'host'
      if @event_time == 'upcoming'
        Event.get_upcoming_events_by_host(@current_host.id)
      else
        Event.get_past_events_by_host(@current_host.id)
      end
    else
      if @event_time == 'upcoming'
        Event.get_upcoming_public_events
      else
        Event.get_past_public_events
      end
    end
  end

  def add
    if request.post?
      @event = Event.new(event_params.merge(host_id: @current_host.id))
      if @event.valid? && @event.save
        redirect_to events_index_path
      else
        flash[:error] = @event.errors.full_messages.map { |v| v }.join('<br/>')
        redirect_to events_add_path
      end
    else
      @event = Event.new
    end
  end

  private

  def event_params
    params.require(:event).permit(:event_name, :description, :capacity, :event_start, :event_end, :rsvp_start, :rsvp_end, :event_type, :venue_addr1, :venue_addr2, :venue_city, :venue_state, :venue_zip)
  end

end