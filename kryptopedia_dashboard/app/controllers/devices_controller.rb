class DevicesController < ApplicationController
  include TeamConcern
  before_action :restrict_to_team_admin

  def index
    @devices = @team.devices
  end

  def new
    @device = @team.devices.new
  end

  def create
    @device = @team.devices.new(device_params)
    if @device.save
      redirect_to team_devices_path(@team), notice: "Device created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def device_params
    params.require(:device).permit(:name)
  end
end
