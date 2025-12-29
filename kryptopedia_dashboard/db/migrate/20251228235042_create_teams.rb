class CreateTeams < ActiveRecord::Migration[8.1]
  def change
    create_table :teams do |t|
      t.integer :number

      t.timestamps
    end
  end
end
