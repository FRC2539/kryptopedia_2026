# == Schema Information
#
# Table name: matches
#
#  id               :bigint           not null, primary key
#  comp_level       :string           not null
#  number           :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  blue1_id         :bigint
#  blue2_id         :bigint
#  blue3_id         :bigint
#  red1_id          :bigint
#  red2_id          :bigint
#  red3_id          :bigint
#  scouted_event_id :bigint           not null
#
# Indexes
#
#  index_matches_on_blue1_id                                    (blue1_id)
#  index_matches_on_blue2_id                                    (blue2_id)
#  index_matches_on_blue3_id                                    (blue3_id)
#  index_matches_on_red1_id                                     (red1_id)
#  index_matches_on_red2_id                                     (red2_id)
#  index_matches_on_red3_id                                     (red3_id)
#  index_matches_on_scouted_event_id                            (scouted_event_id)
#  index_matches_on_scouted_event_id_and_comp_level_and_number  (scouted_event_id,comp_level,number) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (blue1_id => teams.id)
#  fk_rails_...  (blue2_id => teams.id)
#  fk_rails_...  (blue3_id => teams.id)
#  fk_rails_...  (red1_id => teams.id)
#  fk_rails_...  (red2_id => teams.id)
#  fk_rails_...  (red3_id => teams.id)
#  fk_rails_...  (scouted_event_id => scouted_events.id)
#
class Match < ApplicationRecord
  belongs_to :scouted_event

  belongs_to :red1, class_name: "Team"
  belongs_to :red2, class_name: "Team"
  belongs_to :red3, class_name: "Team"
  belongs_to :blue1, class_name: "Team"
  belongs_to :blue2, class_name: "Team"
  belongs_to :blue3, class_name: "Team"

  validates :comp_level, presence: true
  validates :number, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def name
    "#{comp_level.upcase} ##{number}"
  end

  default_scope { order(:comp_level, :number) }
end
