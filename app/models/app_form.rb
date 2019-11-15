class AppForm < ApplicationRecord
  belongs_to :application_status
  belongs_to :final_decision
  belongs_to :funding_status
  belongs_to :user
end
