class CreateSessionRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :session_requests do |t|
      t.references :device, null: false, foreign_key: true
      t.references :scouted_event, null: false, foreign_key: true
      t.references :session, null: true, foreign_key: true
      t.datetime :expires_at

      t.timestamps
    end
  end
end
