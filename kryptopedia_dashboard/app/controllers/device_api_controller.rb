class DeviceApiController < ApplicationController
  include TeamConcern

  def preauth_info
    @events = @team.scouted_events
    @devices = @team.devices
  end
end
