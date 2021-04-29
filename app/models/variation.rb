class Variation < ApplicationRecord
  belongs_to :user
  belongs_to :app_form
  belongs_to :original_app_form, class_name: "AppForm"
end
