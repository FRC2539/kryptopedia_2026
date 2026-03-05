module SoftDeleteConcern
  extend ActiveSupport::Concern

  included do
    scope :alive, -> { where(deleted_at: nil) }
  end

  def deleted?
    deleted_at.present?
  end

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
end