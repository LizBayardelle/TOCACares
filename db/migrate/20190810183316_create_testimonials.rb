class CreateTestimonials < ActiveRecord::Migration[5.2]
  def change
    create_table :testimonials do |t|
      t.string :category
      t.string :title
      t.string :body
      t.boolean :featured, default: false
      t.boolean :approved, default: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
