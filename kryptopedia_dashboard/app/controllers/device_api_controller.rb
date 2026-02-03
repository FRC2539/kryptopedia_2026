class DeviceApiController < ApplicationController
  include TeamConcern

  before_action :restrict_to_team_member, except: [:preauth_info, :request_session, :check_session_request]
  skip_before_action :verify_authenticity_token

  def preauth_info
    @events = @team.scouted_events
    @devices = @team.devices
  end

  def request_session
    device = @team.devices.find_by_hashid(params[:device_id])
    event = @team.scouted_events.find_by_hashid(params[:event_id])
    request = SessionRequest.new(device: device, scouted_event: event)
    request.save!
    render json: { request_id: request.hashid }
  end

  def check_session_request
    request = SessionRequest.alive.find_by_hashid(params[:request_id])
    render json: { error: "not found" }, status: 404 and return unless request
    if request.session
      request.destroy!
      render json: { session_auth_token: request.session.auth_token }
    else
      request.poke
      render json: { session_auth_token: nil }
    end
  end

  def me
    render json: {
      me: current_user.as_json
    }
  end

  def sync
    # TODO: process incoming data

    since = params[:since] ? Time.parse(params[:since]).. : (10.years.ago..)
    event = current_user.active_event

    @synced_to = Time.current
    @teams = ScoutedEventTeam.where(updated_at: since, scouted_event: event)

    puts @teams.count
  end
end
