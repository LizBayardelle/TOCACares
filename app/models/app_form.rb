class AppForm < ApplicationRecord
  belongs_to :application_status, optional: true
  belongs_to :final_decision, optional: true
  belongs_to :funding_status, optional: true
  belongs_to :user, optional: true
end
