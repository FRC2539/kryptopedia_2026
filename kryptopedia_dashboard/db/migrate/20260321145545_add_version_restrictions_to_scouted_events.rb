class AddVersionRestrictionsToScoutedEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :scouted_events, :min_app_version, :string
    add_column :scouted_events, :max_app_version, :string
  end
end
