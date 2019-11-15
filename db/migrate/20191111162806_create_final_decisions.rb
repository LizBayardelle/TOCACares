class CreateFinalDecisions < ActiveRecord::Migration[5.2]
  def change
    create_table :final_decisions do |t|
      t.string :status

      t.timestamps
    end
  end
end
