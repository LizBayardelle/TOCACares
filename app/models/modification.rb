class Modification < ApplicationRecord
  belongs_to :modifiable, polymorphic: true, optional: true
  belongs_to :user
end
