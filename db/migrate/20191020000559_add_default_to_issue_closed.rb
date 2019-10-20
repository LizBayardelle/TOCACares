class AddDefaultToIssueClosed < ActiveRecord::Migration[5.2]
  def change
    change_column :messages, :issue_closed, :boolean, default: false
  end
end
