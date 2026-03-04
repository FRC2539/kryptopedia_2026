class CreatePreloadedFlags < ActiveRecord::Migration[8.1]
  def change
    create_table :preloaded_flags do |t|
      t.string :name
      t.references :scouted_event, null: false, foreign_key: true
      
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
