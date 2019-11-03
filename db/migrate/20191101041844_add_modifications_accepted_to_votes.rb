class AddModificationsAcceptedToVotes < ActiveRecord::Migration[5.2]
  def change
    add_column :votes, :modifications_accepted_by_applicant, :boolean, default: false
  end
end
