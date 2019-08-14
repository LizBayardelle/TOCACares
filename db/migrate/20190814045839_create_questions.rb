class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.string :name
      t.string :email
      t.string :subject
      t.text :body
      t.boolean :answered, default: false

      t.timestamps
    end
  end
end
