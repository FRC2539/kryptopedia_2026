module StatboticsService
  BASE_URL = "https://api.statbotics.io/v3"

  class << self
    def _conn
      @conn ||= Faraday.new url: BASE_URL, request: { timeout: 10 } do |conn|
        conn.response :json
        conn.response :raise_error
      end
    end

    def event_teams(year, event_code)
      _conn.get("team_events?event=#{year}#{event_code}").body
    rescue Faraday::Error => e
      Sentry.logger.error("Statbotics is mad", error: e)
      []
    end
  end
end