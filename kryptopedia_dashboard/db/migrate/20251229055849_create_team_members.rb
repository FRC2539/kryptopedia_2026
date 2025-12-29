class CreateTeamMembers < ActiveRecord::Migration[8.1]
  def change
    create_table :team_members do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.string :email
      t.integer :role

      t.timestamps
    end
  end
end
