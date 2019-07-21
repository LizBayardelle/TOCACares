class Charity < ApplicationRecord
  belongs_to :user, optional: true
end
