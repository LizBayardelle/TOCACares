class Scholarship < ApplicationRecord
  belongs_to :user, optional: true
end
