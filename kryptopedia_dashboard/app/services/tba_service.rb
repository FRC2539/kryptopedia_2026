module TBAService
  BASE_URL = "https://www.thebluealliance.com/api/v3"
  API_KEY = Rails.application.credentials.dig(:tba, :key)

  class << self
    def _conn
      @conn ||= Faraday.new url: BASE_URL do |conn|
        conn.headers["X-TBA-Auth-Key"] = API_KEY
        conn.response :json
        conn.response :raise_error
      end
    end

    def team(team_number)
      _conn.get("team/frc#{team_number}").body
    end

    def team_events_for_year(team_number, year)
      _conn.get("team/frc#{team_number}/events/#{year}/simple").body
    end

    def event_matches(year, event_code)
      _conn.get("event/#{year}#{event_code}/matches").body
    end

    def event_teams(year, event_code)
      _conn.get("event/#{year}#{event_code}/teams/simple").body
    end
  end
end