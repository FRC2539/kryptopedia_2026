# == Schema Information
#
# Table name: scouting_data_items
#
#  id               :bigint           not null, primary key
#  data             :string
#  type             :string
#  uid              :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  scouted_event_id :bigint           not null
#  team_member_id   :bigint           not null
#
# Indexes
#
#  index_scouting_data_items_on_scouted_event_id  (scouted_event_id)
#  index_scouting_data_items_on_team_member_id    (team_member_id)
#
# Foreign Keys
#
#  fk_rails_...  (scouted_event_id => scouted_events.id)
#  fk_rails_...  (team_member_id => team_members.id)
#
class ScoutingDataItem < ApplicationRecord
  belongs_to :team_member
  belongs_to :scouted_event
end
