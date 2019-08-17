class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.string :application_type
      t.integer :application_id

      t.boolean :accept, default: false

      t.boolean :modify, default: false
      t.text :modification
      t.boolean :suggest_loan, default: false
      t.text :describe_loan, default: false
      
      t.boolean :deny, default: false
      t.boolean :denial_fund_overuse, default: false
      t.boolean :denial_not_qualify, default: false
      t.boolean :denial_unreasonable_request, default: false
      t.boolean :denial_not_involved_charity, default: false
      t.boolean :denial_other, default: false
      t.text :denial_other_description

      t.boolean :superseded, default: false
      t.boolean :seconded, default: false

      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
