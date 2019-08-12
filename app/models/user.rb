class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :hardships
  has_many :charities
  has_many :scholarships
  has_many :modifications

  def self.admin_users
    User.where(admin: true)
  end

  def self.committee_users
    User.where(committee: true)
  end

  def self.admin_and_committee_users
    User.where(admin: true, committee: true)
  end
end
