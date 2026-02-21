class CreateMatches < ActiveRecord::Migration[8.1]
  def change
    create_table :matches do |t|
      t.references :scouted_event, null: false, foreign_key: true

      t.references :red1, index: true, foreign_key: { to_table: :teams }
      t.references :red2, index: true, foreign_key: { to_table: :teams }
      t.references :red3, index: true, foreign_key: { to_table: :teams }
      t.references :blue1, index: true, foreign_key: { to_table: :teams }
      t.references :blue2, index: true, foreign_key: { to_table: :teams }
      t.references :blue3, index: true, foreign_key: { to_table: :teams }

      t.string :comp_level, null: false
      t.integer :number, null: false

      t.index [:comp_level, :number], unique: true

      t.timestamps
    end

    add_column :scouted_events, :tba_sync, :boolean, null: false, default: false
  end
end
