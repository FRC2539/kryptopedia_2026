class MatchesController < ApplicationController
  include ScoutedEventConcern
  before_action :restrict_to_team_admin

  def index
    @matches = @scouted_event.matches
  end

  def download_matches_from_tba
    redirect_to edit_team_scouted_event_path(@scouted_event), alert: "TBA Sync is disabled" unless @scouted_event.tba_sync?
    @scouted_event.download_matches_from_tba
    redirect_to team_scouted_event_matches_path(@scouted_event), notice: "Matches downloaded!"
  end
end
