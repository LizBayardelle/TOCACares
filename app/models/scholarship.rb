class Scholarship < ApplicationRecord
  belongs_to :user, optional: true
  has_many :modifications, as: :modifiable
end
