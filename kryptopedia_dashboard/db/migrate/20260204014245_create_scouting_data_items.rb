class CreateScoutingDataItems < ActiveRecord::Migration[8.1]
  def change
    create_table :scouting_data_items do |t|
      t.string :type
      t.string :uid
      t.string :data
      t.references :team_member, null: false, foreign_key: true
      t.references :scouted_event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
