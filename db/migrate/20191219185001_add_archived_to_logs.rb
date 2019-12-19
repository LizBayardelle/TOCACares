class AddArchivedToLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :logs, :archived, :boolean, default: false
  end
end
