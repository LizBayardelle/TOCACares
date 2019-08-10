class AddLoanPreferredToApps < ActiveRecord::Migration[5.2]
  def change
    add_column :hardships, :loan_preferred, :boolean, default: false
    add_column :scholarships, :loan_preferred, :boolean, default: false
    add_column :charities, :loan_preferred, :boolean, default: false
  end
end
