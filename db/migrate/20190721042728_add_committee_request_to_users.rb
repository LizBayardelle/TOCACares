class AddCommitteeRequestToUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :committee_request
    add_column :users, :committee_request, :string, default: "None"
  end
end
