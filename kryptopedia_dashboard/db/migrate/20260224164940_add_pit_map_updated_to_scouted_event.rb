class AddPitMapUpdatedToScoutedEvent < ActiveRecord::Migration[8.1]
  def change
    add_column :scouted_events, :pit_map_cache_updated, :datetime
  end
end
