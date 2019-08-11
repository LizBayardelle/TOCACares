class AddOtherToHardships < ActiveRecord::Migration[5.2]
  def change
    add_column :hardships, :for_other, :boolean, default: false
  end
end
