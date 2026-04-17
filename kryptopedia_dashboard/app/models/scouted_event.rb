# == Schema Information
#
# Table name: scouted_events
#
#  id                    :bigint           not null, primary key
#  code                  :string
#  max_app_version       :string
#  min_app_version       :string
#  name                  :string
#  pit_map_cache_updated :datetime
#  tba_sync              :boolean          default(FALSE), not null
#  test                  :boolean
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  team_id               :bigint           not null
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
  has_many :preloaded_flags

  validates :name, presence: true, uniqueness: { scope: :team_id }
  validates :code, presence: true, uniqueness: { scope: :team_id }
  validates :test, inclusion: [true, false]

  normalizes :min_app_version, :max_app_version, with: -> { it.presence }

  def pit_map
    Rails.cache.fetch("#{code}/pit_map", expires_in: 1.hour) do
      self.update!(pit_map_cache_updated: Time.current)
      NexusService.pit_map(2026, code)
    rescue Faraday::ResourceNotFound
      nil
    end
  end

  def download_matches_from_tba!
    return unless tba_sync?

    TBAService.event_matches(2026, code).each do |match_data|
      comp_level = match_data["comp_level"]
      match_number = comp_level != "sf" ? match_data["match_number"] : match_data["set_number"]
      match = matches.find_or_initialize_by(comp_level: comp_level, number: match_number)
      match.update!(
        red1: Team.find_or_create_by!(number: match_data["alliances"]["red"]["team_keys"][0].delete_prefix("frc").to_i),
        red2: Team.find_or_create_by!(number: match_data["alliances"]["red"]["team_keys"][1].delete_prefix("frc").to_i),
        red3: Team.find_or_create_by!(number: match_data["alliances"]["red"]["team_keys"][2].delete_prefix("frc").to_i),
        blue1: Team.find_or_create_by!(number: match_data["alliances"]["blue"]["team_keys"][0].delete_prefix("frc").to_i),
        blue2: Team.find_or_create_by!(number: match_data["alliances"]["blue"]["team_keys"][1].delete_prefix("frc").to_i),
        blue3: Team.find_or_create_by!(number: match_data["alliances"]["blue"]["team_keys"][2].delete_prefix("frc").to_i),
        start_time: Time.at(match_data["time"])
      )
    end
  end

  def teams_insights
    return [] unless teams and tba_sync?
    Rails.cache.fetch("#{id}/insights", expires_in: 5.minutes) do
      statbotics_insights = StatboticsService.event_teams(2026, code).index_by { |t| t["team"] }
      tba_insights = TBAService.event_oprs(2026, code)
      tba_rankings = TBAService.event_rankings(2026, code)["rankings"].index_by { |r| r["team_key"].delete_prefix("frc").to_i }
      return [] if tba_insights.empty?
      teams.map do |team|
        {
          team_number: team.number,
          opr: tba_insights["oprs"]["frc#{team.number}"],
          dpr: tba_insights["dprs"]["frc#{team.number}"],
          ccwm: tba_insights["ccwms"]["frc#{team.number}"],
          ranking: tba_rankings[team.number] ? tba_rankings[team.number]["rank"] : nil,
          epa: statbotics_insights[team.number] ? statbotics_insights[team.number]["epa"]["total_points"]["mean"] : nil
        }
      end
    end
  end

  def purge_insights_cache!
    Rails.cache.delete("#{id}/insights")
  end

  def match_scouting_assignments
    MatchScoutingAssignment.joins(:match).where(matches: { scouted_event_id: id })
  end

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
