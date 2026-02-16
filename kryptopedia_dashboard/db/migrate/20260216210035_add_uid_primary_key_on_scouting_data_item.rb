class AddUidPrimaryKeyOnScoutingDataItem < ActiveRecord::Migration[8.1]
  def change
    # so upsert properly works
    add_index :scouting_data_items, [:uid, :scouted_event_id], unique: true
  end
end
