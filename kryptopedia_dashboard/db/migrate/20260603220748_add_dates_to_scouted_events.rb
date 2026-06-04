class AddDatesToScoutedEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :scouted_events, :start_date, :date
    add_column :scouted_events, :end_date, :date
    add_index :scouted_events, :start_date

    ScoutedEvent.reset_column_information
    ScoutedEvent.find_each do |event|
      if (event.start_date.nil? || event.end_date.nil?)
        event.update!(start_date: Date.new(2026, 3, 1), end_date: Date.new(2026, 3, 2))
      end
    end

    change_column_null :scouted_events, :start_date, false
    change_column_null :scouted_events, :end_date, false
  end
end
