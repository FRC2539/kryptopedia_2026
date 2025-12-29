module TeamColorsService
  BASE_URL = "https://api.frc-colors.com/v1"

  class << self
    def _conn
      @conn ||= Faraday.new url: BASE_URL do |conn|
        conn.response :json
        conn.response :raise_error
      end
    end

    def team(team_number)
      _conn.get("team/#{team_number}").body
    end
  end
end