class AddSubmittedToAppForms < ActiveRecord::Migration[5.2]
  def change
    add_column :app_forms, :submitted, :boolean, default: false
  end
end
