# == Schema Information
#
# Table name: team_members
#
#  id                 :bigint           not null, primary key
#  email              :string
#  email_code         :integer
#  email_code_sent_at :datetime
#  name               :string
#  role               :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  team_id            :bigint           not null
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
  normalizes :email, with: -> email { email.strip.downcase }
  enum :role, [:scouter, :admin], default: :scouter
  validates :email, uniqueness: { scope: :team_id }

  def send_email_code!
    self.email_code = rand(100000..999999)
    self.email_code_sent_at = Time.current
    save!
    TeamMemberMailer.verification_code_email(self).deliver_later
  end
end
