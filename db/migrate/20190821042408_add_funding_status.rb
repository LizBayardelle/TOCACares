class AddFundingStatus < ActiveRecord::Migration[5.2]
  def change
    add_column :hardships, :funding_status, :string, default: "Not Applicable"
    add_column :scholarships, :funding_status, :string, default: "Not Applicable"
    add_column :charities, :funding_status, :string, default: "Not Applicable"
  end
end
