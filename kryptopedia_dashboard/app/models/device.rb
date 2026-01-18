# == Schema Information
#
# Table name: devices
#
#  id         :bigint           not null, primary key
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
  belongs_to :owner, polymorphic: true

  has_one :session, as: :owner, dependent: :destroy
end
