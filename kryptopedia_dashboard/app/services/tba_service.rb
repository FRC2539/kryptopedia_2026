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

    def teams
      Rails.cache.fetch("tba_teams", expires_in: 7.days) do
        teams = []
        page = 0
        loop do
          response = _conn.get("teams/#{page}",)
          break if response.body.empty?

          teams.concat(response.body)
          page += 1
        end

        teams
      end
    end

    def team(team_number)
      teams.find { |team| team["key"] == "frc#{team_number}" }
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