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
  include Hashid::Rails

  belongs_to :team

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }, uniqueness: { scope: :team_id }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { scope: :team_id }, allow_nil: true
  normalizes :email, with: ->(email) { email.strip.downcase.presence }
  enum :role, [:scouter, :admin], default: :scouter

  has_many :sessions, as: :owner, dependent: :destroy
  has_many :devices, as: :owner, dependent: :destroy

  default_scope { order(:name) }

  def send_email_code!
    self.email_code = rand(100000..999999)
    self.email_code_sent_at = Time.current
    save!
    TeamMemberMailer.verification_code_email(self).deliver_now
  end
end
