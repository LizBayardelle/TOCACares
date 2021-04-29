class AddVariationByToVariations < ActiveRecord::Migration[5.2]
  def change
    add_reference :variations, :user, foreign_key: true
  end
end
