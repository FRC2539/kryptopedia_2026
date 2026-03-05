class MatchesController < ApplicationController
  include ScoutedEventConcern
  before_action :restrict_to_team_admin

  def index
    @matches = @scouted_event.matches
  end

  def download_matches_from_tba
    redirect_to edit_team_scouted_event_path(@scouted_event), alert: "TBA Sync is disabled" unless @scouted_event.tba_sync?

    TBAService.event_matches(2026, @scouted_event.code).each do |match_data|
      comp_level = match_data["key"].delete_prefix("2026#{@scouted_event.code}_").split("m").first
      match = @scouted_event.matches.find_or_initialize_by(comp_level: comp_level, number: match_data["match_number"])
      match.update!(
        red1: Team.find_or_create_by!(number: match_data["alliances"]["red"]["team_keys"][0].delete_prefix("frc").to_i),
        red2: Team.find_or_create_by!(number: match_data["alliances"]["red"]["team_keys"][1].delete_prefix("frc").to_i),
        red3: Team.find_or_create_by!(number: match_data["alliances"]["red"]["team_keys"][2].delete_prefix("frc").to_i),
        blue1: Team.find_or_create_by!(number: match_data["alliances"]["blue"]["team_keys"][0].delete_prefix("frc").to_i),
        blue2: Team.find_or_create_by!(number: match_data["alliances"]["blue"]["team_keys"][1].delete_prefix("frc").to_i),
        blue3: Team.find_or_create_by!(number: match_data["alliances"]["blue"]["team_keys"][2].delete_prefix("frc").to_i)
      )
    end

    redirect_to team_scouted_event_matches_path(@scouted_event), notice: "Matches downloaded!"
  end
end
