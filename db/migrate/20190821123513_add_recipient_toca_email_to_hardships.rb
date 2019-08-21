class AddRecipientTocaEmailToHardships < ActiveRecord::Migration[5.2]
  def change
    add_column :hardships, :recipient_toca_email, :string
    add_column :hardships, :transfer_pending, :boolean, default: false
  end
end
