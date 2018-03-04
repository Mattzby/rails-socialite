class Rsvp < ApplicationRecord
  belongs_to :event
  belongs_to :user

  enum rsvp_status: [:no, :yes], _prefix: true

  validates_uniqueness_of :user_id, scope: :event_id
  validates :guests, numericality: {only_integer: true, greater_than_or_equal_to: 0}

  def self.get_confirmed_rsvps_by_event(event_id)
    self.where(event_id: event_id).where(rsvp_status: 1)
  end

  def self.get_confirmed_rsvps_by_user(user_id)
    self.where(user_id: user_id).where(rsvp_status: 1)
  end

  def self.to_rsvp_list_csv(event_id)
  	rsvps = self.where(event_id: event_id).where.not(rsvp_status: nil).order(rsvp_status: :desc)

  	headers = %w{status first_name last_name email phone_number guests}
  	CSV.generate(headers: true) do |csv|
	  csv << headers

	  rsvps.each do |rsvp|
		  csv << [
		  	rsvp.rsvp_status,
		  	rsvp.user.first_name,
		  	rsvp.user.last_name,
		  	rsvp.user.email_addr,
		  	rsvp.user.phone,
		  	rsvp.guests
		  ]
	  end
  	end
  end

end
