class CreateRsvps < ActiveRecord::Migration[5.1]
  def change
    create_table :rsvps do |t|
      t.references :event, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :rsvp_status, limit: 1, default: nil
      t.integer :guests, default: 0
      
      t.timestamps
    end

    add_index :rsvps, [:event_id, :user_id], :unique => true

  end
end
