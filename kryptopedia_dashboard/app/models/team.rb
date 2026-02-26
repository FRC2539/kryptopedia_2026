# == Schema Information
#
# Table name: teams
#
#  id         :bigint           not null, primary key
#  number     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Team < ApplicationRecord
  validates :number, presence: true, uniqueness: true, numericality: { greater_than: 0, less_than: 10000 }

  has_many :team_members
  has_many :devices, as: :owner
  has_many :scouted_events

  def enrolled?
    team_members.any?
  end

  def nickname
    tba_info["nickname"]
  end

  def rookie_year
    tba_info["rookie_year"]
  end

  def country
    tba_info["country"]
  end

  def website
    tba_info["website"]
  end

  def icon_url
    url = "https://www.thebluealliance.com/avatar/#{Time.current.year}/frc#{number}.png"
    # test URL
    Rails.cache.fetch("#{cache_key}/icon_url", expires_in: 7.days) do
      response = Faraday.get(url)
      if response.status == 200
        url
      else
        nil
      end
    end
  end

  def colors
    Rails.cache.fetch("#{cache_key}/colors", expires_in: 7.days) do
      c = TeamColorsService.team(number)
      { primary: c["primaryHex"], secondary: c["secondaryHex"], verified: c["verified"] }
    end
  end

  def to_param
    number.to_s
  end

  default_scope { order(:number) }

  private

  def tba_info
    TBAService.team(number)
  end
end
