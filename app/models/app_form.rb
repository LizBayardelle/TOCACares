class AppForm < ApplicationRecord
  belongs_to :application_status, optional: true
  belongs_to :final_decision, optional: true
  belongs_to :funding_status, optional: true
  belongs_to :user, optional: true
  # has_many :variations
  # has_many :app_form, through: :variations
end
