class CreateInitialTables < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :first_name, limit: 255, null: false
      t.string :last_name, limit: 255, null: false
      t.string :email_addr, limit: 255, null: false
      t.string :passwd, limit: 64, null: false
      t.string :phone, limit: 255, null: false
      t.string :addr1, limit: 255, null: true, default: nil
      t.string :addr2, limit: 255, null: true, default: nil
      t.string :city, limit: 255, null: true, default: nil
      t.string :state, limit: 255, null: true, default: nil
      t.string :zip, limit: 255, null: true, default: nil
      t.timestamps
    end

    create_table :hosts do |t|
      t.string :business_name, limit: 255, null: false
      t.string :email_addr, limit: 255, null: false
      t.string :passwd, limit: 255, null: false
      t.timestamps
    end

    create_table :events do |t|
      t.integer :host_id, null: false
      t.string :event_name, limit: 255, null: false
      t.text :description, limit: 255, null: true, default: nil
      t.datetime :event_start, null: false
      t.datetime :event_end, null: false
      t.integer :capacity, null: false
      t.datetime :rsvp_start, null: false
      t.datetime :rsvp_end, null: false
      t.integer :event_type, limit: 1, null: false
      t.string :venue_addr1, limit: 255, null: false
      t.string :venue_addr2, limit: 255, null: true, default: nil
      t.string :venue_city, limit: 255, null: false
      t.string :venue_state, limit: 255, null: false
      t.string :venue_zip, limit: 255, null: false
      t.timestamps
    end

    add_index :events, :host_id
  end
end
