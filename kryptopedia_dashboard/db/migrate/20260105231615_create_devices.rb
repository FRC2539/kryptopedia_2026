class CreateDevices < ActiveRecord::Migration[8.1]
  def change
    create_table :devices do |t|
      t.references :owner, polymorphic: true
      t.string :name

      t.timestamps
    end
  end
end
