class CreateScoutedEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :scouted_events do |t|
      t.string :name
      t.string :code
      t.references :team, null: false, foreign_key: true
      t.boolean :test

      t.timestamps
    end
    add_reference :devices, :active_event, null: true, foreign_key: { to_table: :scouted_events }
  end
end
