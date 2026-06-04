module FrcApiService
  BASE_URL = "https://frc-api.firstinspires.org/v3.0/"
  AUTHORIZATION = Base64.strict_encode64("#{Rails.application.credentials.dig(:frc_api, :username)}:#{Rails.application.credentials.dig(:frc_api, :token)}")

  class << self
    def _conn
      @conn ||= Faraday.new url: BASE_URL do |conn|
        conn.headers["Authorization"] = "Basic #{AUTHORIZATION}"
        conn.response :json
        conn.response :raise_error
      end
    end

    def season_summary(year)
      _conn.get(year.to_s).body
    end
  end
end