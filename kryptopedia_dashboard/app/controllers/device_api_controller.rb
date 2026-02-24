class DeviceApiController < ApplicationController
  include TeamConcern

  before_action :restrict_to_team_member, except: [:preauth_info, :request_session, :check_session_request, :cancel_session_request]
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

  def cancel_session_request
    request = SessionRequest.alive.find_by_hashid(params[:request_id])
    render json: { error: "not found" }, status: 404 and return unless request
    request.destroy!
    render json: { success: true }
  end

  def me
    render json: {
      me: current_user.as_json
    }
  end

  def sync
    render json: { error: "no" }, status: :forbidden and return if current_user.is_a? TeamMember # very good protection im so good at this

    event = current_user.active_event

    body = JSON.parse(request.body.read) rescue nil
    render json: { error: "invalid json" }, status: :bad_request and return unless body.is_a?(Array)

    body.each do |item|
      data = item["data"]
      if item["deleted"]
        ScoutingDataItem.where(data_type: item["type"], uid: data["uid"], scouted_event_id: event.id).update_all(deleted_at: Time.current)
        next
      end
      team_member = TeamMember.find_by_hashid(data["scouter_id"]) if data["scouter_id"]
      ScoutingDataItem.upsert({ data_type: item["type"], uid: data["uid"], scouted_event_id: event.id, team_member_id: team_member&.id, data: data.to_json, deleted_at: nil })
    end

    # ACCEPT/PUSH ^^
    # SEND/PULL vv

    since = params[:since] ? Time.parse(params[:since]).. : (10.years.ago..)

    @synced_to = Time.current
    @teams = ScoutedEventTeam.where(updated_at: since, scouted_event: event)
    @team_members = TeamMember.where(updated_at: since, team: current_user.team)
    @scouting_data_items = event.scouting_data_items.where(updated_at: since)
    @matches = event.matches.where(updated_at: since)

    current_user.update! last_sync: @synced_to
  end

end
