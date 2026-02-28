# == Schema Information
#
# Table name: scouting_data_items
#
#  id               :bigint           not null, primary key
#  data             :jsonb            not null
#  data_type        :string           not null
#  deleted_at       :datetime
#  uid              :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  scouted_event_id :bigint           not null
#  team_member_id   :bigint
#
# Indexes
#
#  index_scouting_data_items_on_scouted_event_id          (scouted_event_id)
#  index_scouting_data_items_on_team_member_id            (team_member_id)
#  index_scouting_data_items_on_uid_and_scouted_event_id  (uid,scouted_event_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (scouted_event_id => scouted_events.id)
#  fk_rails_...  (team_member_id => team_members.id)
#
class ScoutingDataItem < ApplicationRecord
  belongs_to :team_member, optional: true
  belongs_to :scouted_event

  validates :uid, presence: true, uniqueness: { scope: :scouted_event_id }
  validates :data_type, presence: true
  validates :data, presence: true

  def deleted?
    deleted_at.present?
  end

  def destroy
    soft_delete
  end

  def delete
    soft_delete
  end

  def soft_delete
    return if deleted_at.present?
    update!(deleted_at: Time.current)
  end

  scope :alive, -> { where(deleted_at: nil) }
end
