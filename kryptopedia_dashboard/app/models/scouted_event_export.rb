# == Schema Information
#
# Table name: scouted_event_exports
#
#  id                :bigint           not null, primary key
#  excludes_comments :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  scouted_event_id  :bigint           not null
#  team_member_id    :bigint           not null
#
# Indexes
#
#  index_scouted_event_exports_on_scouted_event_id  (scouted_event_id)
#  index_scouted_event_exports_on_team_member_id    (team_member_id)
#
# Foreign Keys
#
#  fk_rails_...  (scouted_event_id => scouted_events.id)
#  fk_rails_...  (team_member_id => team_members.id)
#
class ScoutedEventExport < ApplicationRecord
  belongs_to :scouted_event
  belongs_to :team_member

  has_one_attached :file
end
