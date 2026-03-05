class ScoutedEventsController < ApplicationController
  include TeamConcern
  before_action :restrict_to_team_admin

  # doesnt make any sense idk why i have to do this something with the concerns
  layout "scouted_events", except: :index
  layout "teams", only: :index

  def index
    @scouted_events = @team.scouted_events
  end

  def edit
    @scouted_event = @team.scouted_events.find_by_hashid!(params[:id])
  end

  def update
    @scouted_event = @team.scouted_events.find_by_hashid!(params[:id])
    if @scouted_event.update(scouted_event_params)
      redirect_to edit_team_scouted_event_path(@team), notice: "Scouted event updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def index_teams
    @scouted_event = @team.scouted_events.find_by_hashid!(params[:scouted_event_id])
    @teams = @scouted_event.teams
  end

  def download_teams
    @scouted_event = @team.scouted_events.find_by_hashid!(params[:scouted_event_id])
    redirect_to edit_team_scouted_event_path(@scouted_event), alert: "TBA Sync is disabled" and return unless @scouted_event.tba_sync?

    teams_numbers = TBAService.event_teams(2026, @scouted_event.code).map { |team_data| team_data["team_number"] }
    teams = teams_numbers.map { |num| Team.find_or_create_by!(number: num) }

    @scouted_event.teams = teams

    redirect_to team_scouted_event_teams_path(@scouted_event), notice: "Teams downloaded!"
  end

  private

  def scouted_event_params
    params.require(:scouted_event).permit(:name, :code, :tba_sync)
  end

end
