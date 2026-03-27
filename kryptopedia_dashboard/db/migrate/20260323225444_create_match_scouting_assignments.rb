class CreateMatchScoutingAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :match_scouting_assignments do |t|
      t.references :match, null: false, foreign_key: true
      t.references :team_member, null: false, foreign_key: true
      t.string :position, null: false

      t.timestamps
    end
    add_column :matches, :start_time, :datetime
  end
end
