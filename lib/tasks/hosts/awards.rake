namespace :hosts do
	require 'csv'

	desc "Creates CSV of Hosts with most positive RSVPs in the given year. Places CSV in 'csv' directory."
	task :awards, [:year] => :environment do |t, args|
		args.with_defaults(year: Time.now.year)
		Dir.mkdir("csv") unless File.exists?("csv")

	  #Active Record Method
	  records = Rsvp.select(
					  [
					    :business_name, Arel.star.count.as('positive_rsvps')
					  ]
					).where(
					  Rsvp.arel_table[:rsvp_status].eq(1).and(
					    Arel::Nodes::NamedFunction.new('year', [Arel::Nodes::SqlLiteral.new('event_end')]).eq(Arel::Nodes.build_quoted(args[:year]))
					  )
					).joins(
					  Rsvp.arel_table.join(Event.arel_table).on(
					    Rsvp.arel_table[:event_id].eq(Event.arel_table[:id])
					  ).join_sources
					).joins(
					  Rsvp.arel_table.join(Host.arel_table).on(
					    Event.arel_table[:host_id].eq(Host.arel_table[:id])
					  ).join_sources
					).order('positive_rsvps').reverse_order.group(:business_name).limit(5)

		CSV.open("csv/arel-host-awards-#{args[:year]}.csv","w") do |csv|
	  	records.each do |record|
				csv << [record.business_name, record.positive_rsvps]
			end
		end

		#Raw SQL Method
		sql = "SELECT business_name, count(*) as positive_rsvps
					FROM socialite_development.rsvps rsvps
					JOIN socialite_development.events events ON rsvps.event_id = events.id
					JOIN socialite_development.hosts hosts ON events.host_id = hosts.id
					WHERE rsvp_status = 1 and year(event_end) = #{args[:year]}
					GROUP BY business_name
					ORDER BY positive_rsvps desc
					LIMIT 5"
		records_array = ActiveRecord::Base.connection.execute(sql)

		CSV.open("csv/sql-host-awards-#{args[:year]}.csv","w") do |csv|
			records_array.each do |record|
				csv << [record[0], record[1]]
			end
		end
	end
end