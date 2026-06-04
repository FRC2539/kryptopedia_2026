class Season

  attr_reader :year

  def initialize(year)
    @year = year
  end

  def long_game_name
    Rails.cache.fetch("season_title_#{year}", expires_in: 1.week) do
      FrcApiService.season_summary(year)["gameName"]
    rescue Faraday::BadRequestError
      nil
    end
  end

  def game_name
    long_game_name&.split(/ presented by /i)&.first&.delete_suffix("™")
  end
end