# == Schema Information
#
# Table name: scouted_events
#
#  id         :bigint           not null, primary key
#  code       :string
#  name       :string
#  tba_sync   :boolean          default(FALSE), not null
#  test       :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :bigint           not null
#
# Indexes
#
#  index_scouted_events_on_team_id  (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#
class ScoutedEvent < ApplicationRecord
  include Hashid::Rails

  belongs_to :owner, class_name: "Team", foreign_key: "team_id"
  has_many :scouted_event_teams
  has_many :teams,
           -> { where(scouted_event_teams: { deleted_at: nil }) },
           through: :scouted_event_teams,
           before_add: :revive_or_create_join,
           before_remove: :soft_remove_team_from_event
  has_many :scouting_data_items
  has_many :matches

  validates :name, presence: true, uniqueness: { scope: :team_id }
  validates :code, presence: true, uniqueness: { scope: :team_id }
  validates :test, presence: true

  private

  def revive_or_create_join(team)
    join = ScoutedEventTeam.unscoped.find_or_initialize_by(
      scouted_event_id: id,
      team_id: team.id
    )

    # If it was soft-deleted, revive by clearing deleted_at.
    if join.new_record?
      join.deleted_at = nil
      join.save!
    elsif join.deleted_at.present?
      join.update!(deleted_at: nil)
    end

    # Stop Rails from trying to create another join record after callback.
    throw(:abort)
  end

  def soft_remove_team_from_event(team)
    scouted_event_teams
      .where(team_id: team.id, deleted_at: nil)
      .update_all(deleted_at: Time.current, updated_at: Time.current)

    throw(:abort)
  end
end
