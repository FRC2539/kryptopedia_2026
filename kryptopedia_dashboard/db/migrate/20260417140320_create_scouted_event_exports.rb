class CreateScoutedEventExports < ActiveRecord::Migration[8.1]
  def change
    create_table :scouted_event_exports do |t|
      t.references :scouted_event, null: false, foreign_key: true
      t.boolean :excludes_comments
      t.references :team_member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
