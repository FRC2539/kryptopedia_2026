class TeamMembersController < ApplicationController
  include TeamConcern
  layout "teams"
  before_action :restrict_to_team_admin

  def index
    @team_members = @team.team_members.order(:name)
  end
end
