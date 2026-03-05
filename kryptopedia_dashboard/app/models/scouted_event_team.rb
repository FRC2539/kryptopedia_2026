# == Schema Information
#
# Table name: scouted_event_teams
#
#  id               :bigint           not null, primary key
#  deleted_at       :datetime
#  updated_at       :datetime
#  scouted_event_id :bigint
#  team_id          :bigint
#
# Indexes
#
#  index_scouted_event_teams_on_scouted_event_id  (scouted_event_id)
#  index_scouted_event_teams_on_team_id           (team_id)
#  index_set_on_event_id_and_team_id              (scouted_event_id,team_id) UNIQUE
#
class ScoutedEventTeam < ApplicationRecord
  belongs_to :scouted_event
  belongs_to :team

  include SoftDeleteConcern

  scope :alive, -> { where(deleted_at: nil) }
end
