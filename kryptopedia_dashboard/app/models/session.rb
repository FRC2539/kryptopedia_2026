# == Schema Information
#
# Table name: sessions
#
#  id         :bigint           not null, primary key
#  auth_token :string
#  owner_type :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :bigint
#
# Indexes
#
#  index_sessions_on_auth_token  (auth_token) UNIQUE
#  index_sessions_on_owner       (owner_type,owner_id)
#
class Session < ApplicationRecord
  include Hashid::Rails

  before_create :delete_other_sessions

  belongs_to :owner, polymorphic: true
  has_one :session_request, dependent: :destroy

  has_secure_token :auth_token

  private

  def delete_other_sessions
    Session.where(owner: owner).delete_all
  end
end
