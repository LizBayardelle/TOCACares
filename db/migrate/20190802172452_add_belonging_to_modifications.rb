class AddBelongingToModifications < ActiveRecord::Migration[5.2]
  def change
    add_column :modifications, :app_type, :string
    add_column :modifications, :app_id, :integer
    add_column :modifications, :superseded, :boolean, default: false
  end
end
