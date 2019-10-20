class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.integer :from_user_id
      t.references :user, foreign_key: true
      t.string :subject
      t.text :message
      t.boolean :read, default: false
      t.string :ref_application_type
      t.integer :ref_application_id
      t.boolean :issue_closed

      t.timestamps
    end
  end
end
