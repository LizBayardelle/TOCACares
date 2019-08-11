class CreateAuthorizations < ActiveRecord::Migration[5.2]
  def change
    create_table :authorizations do |t|
      t.string :email
      t.boolean :admin, default: false
      t.boolean :committee, default: false
      t.boolean :account_created, default: false

      t.timestamps
    end
  end
end
