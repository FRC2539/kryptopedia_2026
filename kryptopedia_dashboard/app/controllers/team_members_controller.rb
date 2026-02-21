class TeamMembersController < ApplicationController
  include TeamConcern
  before_action :restrict_to_team_admin

  def index
    @team_members = @team.team_members
  end

  def new
    @team_member = @team.team_members.new
  end

  def create
    @team_member = @team.team_members.new(team_member_params)
    if @team_member.save
      redirect_to team_team_members_path(@team), notice: "Team member created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @team_member = @team.team_members.find_by_hashid!(params[:id])
  end

  def update
    @team_member = @team.team_members.find_by_hashid!(params[:id])
    if @team_member.update(team_member_params)
      redirect_to team_team_members_path(@team), notice: "Team member updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def team_member_params
    params.require(:team_member).permit(:name, :email)
  end
end
