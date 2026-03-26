class DeviceApiController < ApplicationController
  include TeamConcern

  before_action :restrict_to_device, except: [:preauth_info, :request_session, :check_session_request, :cancel_session_request]
  before_action :get_headers
  skip_before_action :verify_authenticity_token

  def preauth_info
    @events = @team.scouted_events

    @events = @events.select do |event|
      current_version = Gem::Version.new(@app_version)
      return false if event.min_app_version.present? and current_version < Gem::Version.new(event.min_app_verision)
      return false if event.max_app_version.present? and current_version > Gem::Version.new(event.max_app_version)
      true
    end
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
    @event = current_user.active_event

    body = JSON.parse(request.body.read) rescue nil
    render json: { error: "invalid json" }, status: :bad_request and return unless body.is_a?(Array)

    body.each do |item|
      data = item["data"]
      if item["deleted"]
        ScoutingDataItem.where(data_type: item["type"], uid: item["uid"], scouted_event_id: @event.id).update_all(deleted_at: Time.current)
        next
      end
      team_member = TeamMember.find_by_hashid(item["scouter_id"]) if item["scouter_id"]
      ScoutingDataItem.upsert({ data_type: item["type"], uid: item["uid"], scouted_event_id: @event.id, team_member_id: team_member&.id, data: data, deleted_at: nil })
    end

    # ACCEPT/PUSH ^^
    # SEND/PULL vv

    since = params[:since] ? Time.parse(params[:since]).. : (10.years.ago..)

    from_clean = ActiveModel::Type::Boolean.new.cast(params[:from_clean]) # can ignore sending deleted items back to the client, since their DB is empty anyway

    @synced_to = Time.current

    @teams = ScoutedEventTeam.where(updated_at: since, scouted_event: @event)
    @teams = @teams.where(deleted_at: nil) if from_clean
    @team_members = TeamMember.where(updated_at: since, team: current_user.team)
    @scouting_data_items = @event.scouting_data_items.where(updated_at: since)
    @scouting_data_items = @scouting_data_items.where(deleted_at: nil) if from_clean
    @matches = @event.matches.where(updated_at: since)
    @pit_map = @event.pit_map # force cache check/update
    @should_update_pit_map = since.include?(@event.pit_map_cache_updated)
    @preloaded_flags = @event.preloaded_flags.where(updated_at: since)
    @preloaded_flags = @preloaded_flags.where(deleted_at: nil) if from_clean

    @insights = @event.teams_insights

    current_user.update! last_sync: @synced_to
  end

  def upload_scouting_data_item_photo
    event = current_user.active_event

    item = event.scouting_data_items.find_by!(uid: params[:uid])
    item.image.attach(params[:photo])
    item.save!
    item.reload
    render json: { upload_time: item.image.blob.created_at.to_i * 1000 }
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def download_scouting_data_item_photo
    event = current_user.active_event

    item = event.scouting_data_items.find_by!(uid: params[:uid])
    return head :not_found unless item.image.attached?
    redirect_to url_for(item.image), allow_other_host: true
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  private

  def get_headers
    @app_version = request.headers["X-App-Version"]
    head :bad_request unless @app_version.present?
  end

end
