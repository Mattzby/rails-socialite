module ApplicationHelper

  #calculates how many free slots available to an event by
  #looking at guest amounts on each rsvp to the event, and
  #counting the user themself
  def calculate_free_capacity_for_event (event)
    total_rsvp_guests = 0
    total_rsvp_users = 0
    event.rsvps.each do |rsvp|
      if rsvp.rsvp_status == 'yes'
        total_rsvp_guests += rsvp.guests
        total_rsvp_users += 1
      end
    end
    return event.capacity - total_rsvp_guests - total_rsvp_users
  end
  
end
