# what a name
class MakeScoutingDataItemTeamMemberOptional < ActiveRecord::Migration[8.1]
  def change
    change_column_null :scouting_data_items, :team_member_id, true
  end
end
