class AssociateEventTeams < ActiveRecord::Migration[8.1]
  def change
    create_table :scouted_event_teams do |t|
      t.belongs_to :scouted_event
      t.belongs_to :team

      t.datetime :deleted_at
      t.datetime :updated_at
    end
    
    add_index :scouted_event_teams, [:scouted_event_id, :team_id], unique: true, name: "index_set_on_event_id_and_team_id"

  end
end
