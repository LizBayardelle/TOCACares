class CreateModifications < ActiveRecord::Migration[5.2]
  def change
    create_table :modifications do |t|
      t.text :body
      t.boolean :seconded, default: false
      t.references :modifiable, polymorphic: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
