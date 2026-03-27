class ScoutedEventsController < ApplicationController
  include TeamConcern
  before_action :restrict_to_team_admin, except: [:schedule]
  before_action :set_scouted_event, except: [:index, :edit, :update]

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
    @teams = @scouted_event.teams
  end

  def download_teams
    redirect_to edit_team_scouted_event_path(@scouted_event), alert: "TBA Sync is disabled" and return unless @scouted_event.tba_sync?

    teams_numbers = TBAService.event_teams(2026, @scouted_event.code).map { |team_data| team_data["team_number"] }
    teams = teams_numbers.map { |num| Team.find_or_create_by!(number: num) }

    @scouted_event.teams = teams

    redirect_to team_scouted_event_teams_path(@scouted_event), notice: "Teams downloaded!"
  end

  def schedule
    @matches = @scouted_event.matches
    # existing_assignments = @scouted_event.match_scouting_assignments
    # @assignments = @matches.map do |match|
    #
    # end
    @can_edit = current_user&.admin? && current_user.team == @team
  end

  private

  def scouted_event_params
    params.require(:scouted_event).permit(:name, :code, :tba_sync, :min_app_version, :max_app_version)
  end

  def set_scouted_event
    @scouted_event = @team.scouted_events.find_by_hashid!(params[:scouted_event_id])
  end

end
