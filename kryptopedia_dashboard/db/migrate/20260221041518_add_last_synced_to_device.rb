class AddLastSyncedToDevice < ActiveRecord::Migration[8.1]
  def change
    add_column :devices, :last_sync, :datetime
  end
end
