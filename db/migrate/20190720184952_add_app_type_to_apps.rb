class AddAppTypeToApps < ActiveRecord::Migration[5.2]
  def change
    add_column :scholarships, :application_type, :string, default: "scholarship"
    add_column :hardships, :application_type, :string, default: "hardship"
    add_column :charities, :application_type, :string, default: "charity"
  end
end
