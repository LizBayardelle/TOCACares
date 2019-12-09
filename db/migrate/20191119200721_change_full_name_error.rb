class ChangeFullNameError < ActiveRecord::Migration[5.2]
  def change
    rename_column :app_forms, :full, :full_name
  end
end
