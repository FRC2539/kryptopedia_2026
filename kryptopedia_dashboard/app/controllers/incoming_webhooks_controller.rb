class IncomingWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  WEBHOOK_SECRET = Rails.application.credentials.dig(:tba, :webhook_secret)

  def index
    tba_code = Rails.cache.read("tba_webhook_verification_key")
    render json: { tba_verification_key: tba_code }
  end

  def tba
    body = request.body.read
    signature = request.headers["X-TBA-HMAC"]

    unless signature.present? && ActiveSupport::SecurityUtils.secure_compare(signature, OpenSSL::HMAC.hexdigest('SHA256', WEBHOOK_SECRET, body))
      head :unauthorized
      return
    end

    payload = JSON.parse(body)
    type = payload["message_type"]
    data = payload["message_data"]

    case type
    when "verification"
      key = data["verification_key"]
      Rails.cache.write("tba_webhook_verification_key", key, expires_in: 1.hour)
    when "schedule_updated"
      event_code = data["event_key"].sub(/^\d+/, "")
      events = ScoutedEvent.where(code: event_code, tba_sync: true)
      events.each do |event|
        event.download_matches_from_tba!
      end
    when "match_score"
      # not too many database queries im sure
      event_code = data["event_key"].sub(/^\d+/, "")
      events = ScoutedEvent.where(code: event_code, tba_sync: true)
      events.each do |event|
        event.purge_insights_cache!
      end
    end

    head :accepted
  end
end
