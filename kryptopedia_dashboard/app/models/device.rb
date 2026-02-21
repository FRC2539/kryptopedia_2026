# == Schema Information
#
# Table name: devices
#
#  id              :bigint           not null, primary key
#  last_sync       :datetime
#  name            :string
#  owner_type      :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  active_event_id :bigint
#  owner_id        :bigint
#
# Indexes
#
#  index_devices_on_active_event_id  (active_event_id)
#  index_devices_on_owner            (owner_type,owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (active_event_id => scouted_events.id)
#
class Device < ApplicationRecord
  include Hashid::Rails

  belongs_to :owner, polymorphic: true

  validates :name, presence: true, uniqueness: { scope: :owner_id }

  has_one :session, as: :owner, dependent: :destroy
  belongs_to :active_event, class_name: "ScoutedEvent", optional: true

  default_scope { order(:name) }

  def team
    owner.is_a?(Team) ? owner : owner.team
  end
end
