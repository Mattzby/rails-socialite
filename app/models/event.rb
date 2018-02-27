class Event < ApplicationRecord

  belongs_to :host

  enum event_type: [:public, :invite], _prefix: true

  validates :event_name, :capacity, :event_start, :event_end, :rsvp_start, :rsvp_end, :event_type, :venue_addr1, :venue_city, :venue_state, :venue_zip, presence: true

  def self.get_upcoming_public_events
    self.where(event_type: :public).where('`event_start` >= ?', Time.now)
  end

  def self.get_past_public_events
    self.where(event_type: :public).where('`event_start` < ?', Time.now)
  end

  def self.get_upcoming_events_by_host(host_id)
    self.where(host_id: host_id).where('`event_start` >= ?', Time.now)
  end

  def self.get_past_events_by_host(host_id)
    self.where(host_id: host_id).where('`event_start` < ?', Time.now)
  end

end