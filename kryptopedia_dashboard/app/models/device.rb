# == Schema Information
#
# Table name: devices
#
#  id         :bigint           not null, primary key
#  last_sync  :datetime
#  name       :string
#  owner_type :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :bigint
#
# Indexes
#
#  index_devices_on_owner  (owner_type,owner_id)
#
class Device < ApplicationRecord
  include Hashid::Rails

  belongs_to :owner, polymorphic: true

  validates :name, presence: true, uniqueness: { scope: :owner_id }

  has_one :session, as: :owner, dependent: :destroy

  default_scope { order(:name) }

  def team
    owner.is_a?(Team) ? owner : owner.team
  end

  def active_event
    session.scouted_event if session&.scouted_event
  end

end
