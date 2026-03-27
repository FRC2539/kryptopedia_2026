# == Schema Information
#
# Table name: match_scouting_assignments
#
#  id             :bigint           not null, primary key
#  position       :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  match_id       :bigint           not null
#  team_member_id :bigint           not null
#
# Indexes
#
#  index_match_scouting_assignments_on_match_id        (match_id)
#  index_match_scouting_assignments_on_team_member_id  (team_member_id)
#
# Foreign Keys
#
#  fk_rails_...  (match_id => matches.id)
#  fk_rails_...  (team_member_id => team_members.id)
#
class MatchScoutingAssignment < ApplicationRecord
  belongs_to :match
  belongs_to :team_member
  enum :position, [:red1, :red2, :red3, :blue1, :blue2, :blue3]

  default_scope -> { order(:match_id) }
end
