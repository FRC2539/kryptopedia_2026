module StatboticsService
  BASE_URL = "https://api.statbotics.io/v3"

  class << self
    def _conn
      @conn ||= Faraday.new url: BASE_URL do |conn|
        conn.response :json
        conn.response :raise_error
      end
    end

    def event_team(year, event_code, team_number)
      _conn.get("team_event/#{team_number}/#{year}#{event_code}").body
    end

    def event_teams(year, event_code)
      _conn.get("team_events?event=#{year}#{event_code}").body
    end
  end
end