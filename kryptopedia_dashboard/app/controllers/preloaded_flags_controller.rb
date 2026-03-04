class PreloadedFlagsController < ApplicationController
  include ScoutedEventConcern
  before_action :restrict_to_team_admin

  def index
    @flags = @scouted_event.preloaded_flags.alive
  end

  def show
    @flag = @scouted_event.preloaded_flags.find(params[:id])
  end

  def new
    @flag = @scouted_event.preloaded_flags.new
  end

  def create
    @flag = @scouted_event.preloaded_flags.new(flag_params)
    if @flag.save
      redirect_to team_scouted_event_preloaded_flags_path(@scouted_event.owner, @scouted_event), notice: "Flag added!"
    else
      render :new
    end
  end

  def destroy
    @flag = @scouted_event.preloaded_flags.find(params[:id])
    @flag.destroy
    redirect_to team_scouted_event_preloaded_flags_path(@scouted_event.owner, @scouted_event), notice: "Flag removed!"
  end

  private

  def flag_params
    params.require(:preloaded_flag).permit(:name)
  end
end
