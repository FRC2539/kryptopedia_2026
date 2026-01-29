# == Schema Information
#
# Table name: scouted_events
#
#  id         :bigint           not null, primary key
#  code       :string
#  name       :string
#  test       :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :bigint           not null
#
# Indexes
#
#  index_scouted_events_on_team_id  (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#
class ScoutedEvent < ApplicationRecord
  include Hashid::Rails
  
  belongs_to :team

  validates :name, presence: true
  validates :code, presence: true
  validates :test, presence: true
end
