class CreateApplicationStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :application_statuses do |t|
      t.string :status

      t.timestamps
    end
  end
end
