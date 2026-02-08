class CreateScoutingDataItems < ActiveRecord::Migration[8.1]
  def change
    create_table :scouting_data_items do |t|
      t.string :data_type, null: false
      t.string :uid, null: false
      t.jsonb :data, null: false
      t.references :team_member, null: false, foreign_key: true
      t.references :scouted_event, null: false, foreign_key: true

      t.datetime :deleted_at

      t.timestamps
    end
  end
end
