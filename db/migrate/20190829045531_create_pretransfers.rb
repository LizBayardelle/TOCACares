class CreatePretransfers < ActiveRecord::Migration[5.2]
  def change
    create_table :pretransfers do |t|
      t.string :toca_email
      t.string :application_type
      t.integer :application_id
      t.boolean :open, default: false

      t.timestamps
    end
  end
end
