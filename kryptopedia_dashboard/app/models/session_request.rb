# == Schema Information
#
# Table name: session_requests
#
#  id               :bigint           not null, primary key
#  expires_at       :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  device_id        :bigint           not null
#  scouted_event_id :bigint           not null
#  session_id       :bigint
#
# Indexes
#
#  index_session_requests_on_device_id         (device_id)
#  index_session_requests_on_scouted_event_id  (scouted_event_id)
#  index_session_requests_on_session_id        (session_id)
#
# Foreign Keys
#
#  fk_rails_...  (device_id => devices.id)
#  fk_rails_...  (scouted_event_id => scouted_events.id)
#  fk_rails_...  (session_id => sessions.id)
#
class SessionRequest < ApplicationRecord
  include Hashid::Rails

  belongs_to :device
  belongs_to :scouted_event
  belongs_to :session, optional: true

  validates :expires_at, presence: true
  after_initialize :set_defaults

  def poke
    self.update!(expires_at: 2.minutes.from_now)
  end

  scope :alive, -> { where(expires_at: Time.current..) }

  private

  def set_defaults
    self.expires_at ||= 2.minutes.from_now
  end

end
