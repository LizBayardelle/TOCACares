class CreateVariations < ActiveRecord::Migration[5.2]
  def change
    create_table :variations do |t|
      t.belongs_to :app_form
      t.belongs_to :original_app_form
      t.index [:app_form_id, :original_app_form_id], unique: true
      t.timestamps
    end
  end
end
