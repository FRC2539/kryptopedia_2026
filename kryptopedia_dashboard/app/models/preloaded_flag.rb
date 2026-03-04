# == Schema Information
#
# Table name: preloaded_flags
#
#  id               :bigint           not null, primary key
#  deleted_at       :datetime
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  scouted_event_id :bigint           not null
#
# Indexes
#
#  index_preloaded_flags_on_scouted_event_id  (scouted_event_id)
#
# Foreign Keys
#
#  fk_rails_...  (scouted_event_id => scouted_events.id)
#
class PreloadedFlag < ApplicationRecord
  include Hashid::Rails
  belongs_to :scouted_event

  def destroy
    soft_delete
  end

  def delete
    soft_delete
  end

  def soft_delete
    return if deleted_at.present?
    update!(deleted_at: Time.current)
  end

  scope :alive, -> { where(deleted_at: nil) }
end
