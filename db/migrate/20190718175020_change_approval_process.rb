class ChangeApprovalProcess < ActiveRecord::Migration[5.2]
  def change
    remove_column :hardships, :review_first_status
    remove_column :hardships, :review_first_reviewer_id
    remove_column :hardships, :review_second_status
    remove_column :hardships, :review_second_reviewer_id
    add_column :hardships, :approvals, :text, array: true, default: []
    add_column :hardships, :rejections, :text, array: true, default: []
  end
end
