class AddFieldsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admin, :boolean, default: false
    add_column :users, :committee, :boolean, default: false
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone, :string
    add_column :users, :location, :string
    add_column :users, :committee_request, :boolean, default: false
  end
end
