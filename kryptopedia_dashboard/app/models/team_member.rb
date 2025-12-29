# == Schema Information
#
# Table name: team_members
#
#  id         :bigint           not null, primary key
#  email      :string
#  name       :string
#  role       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :bigint           not null
#
# Indexes
#
#  index_team_members_on_team_id  (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#
class TeamMember < ApplicationRecord
  belongs_to :team

  validates :name, presence: true, length: { maximum: 100 }, uniqueness: { scope: :team_id }
  validates :email, length: { maximum: 255 }, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { scope: :team_id }
  enum :role, [ :scouter, :admin ], default: :scouter
end
