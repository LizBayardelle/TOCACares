class FixSecondReviewerVariableName < ActiveRecord::Migration[5.2]
  def change
    rename_column :hardships, :review_second, :review_second_status
    add_column :hardships, :returned, :boolean, default: false
  end
end
