class MoveDeviceActiveEventToSession < ActiveRecord::Migration[8.1]
  def change
    add_reference :sessions, :scouted_event, null: true, index: true

    Device.find_each do |device|
      if device.active_event_id.present?
        Session.where(owner: device).update_all(scouted_event_id: device.active_event_id)
      end
    end

    remove_reference :devices, :active_event, null: true, foreign_key: { to_table: :scouted_events }
  end
end
