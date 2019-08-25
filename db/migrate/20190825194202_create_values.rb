class CreateValues < ActiveRecord::Migration[5.2]
  def change
    create_table :values do |t|
      t.string :current_year
      t.string :matching_ratio
      t.string :individual_contributions
      t.string :shareholder_matching
      t.string :total_fund_value
      t.boolean :selected, default: false

      t.timestamps
    end
  end
end
