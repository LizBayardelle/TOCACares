class AddAuthorizationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :authorized_by_admin, :boolean, default: false
  end
end
