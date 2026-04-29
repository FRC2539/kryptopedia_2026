module NexusService
  BASE_URL = "https://frc.nexus/api/v1/"
  API_KEY = Rails.application.credentials.dig(:nexus, :key)

  class << self
    def _conn
      @conn ||= Faraday.new url: BASE_URL do |conn|
        conn.headers["Nexus-Api-Key"] = API_KEY
        conn.response :json
        conn.response :raise_error
      end
    end

    def pit_map(year, event_code)
      event = TBAService.event_info(year, event_code)
      code = event["first_event_code"] || event_code
      _conn.get("event/#{year}#{code}/map").body
    end
  end
end