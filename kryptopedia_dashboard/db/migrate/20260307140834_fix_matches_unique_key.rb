class FixMatchesUniqueKey < ActiveRecord::Migration[8.1]
  def change
    remove_index :matches, [:comp_level, :number]
    add_index :matches, [:scouted_event_id, :comp_level, :number], unique: true
  end
end
