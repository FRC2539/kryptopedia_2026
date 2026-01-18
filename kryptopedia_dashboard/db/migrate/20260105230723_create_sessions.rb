class CreateSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :sessions do |t|
      t.string :auth_token
      t.references :owner, polymorphic: true

      t.timestamps
    end
    add_index :sessions, :auth_token, unique: true
  end
end
