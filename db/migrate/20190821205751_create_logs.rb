class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.string :category, default: "Other"
      t.string :action
      t.boolean :automatic, default: false
      t.boolean :object, default: false
      t.boolean :object_linkable, default: false
      t.string :object_category
      t.integer :object_id
      t.boolean :taken_by_user, default: false
      t.integer :user_id

      t.timestamps
    end
  end
end
