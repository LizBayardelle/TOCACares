class AddForOtherEmailToHardships < ActiveRecord::Migration[5.2]
  def change
    add_column :hardships, :for_other_email, :string
  end
end
