class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :charities
  has_many :hardships
  has_many :scholarships
  has_many :testimonials
  has_many :logs
  has_many :messages
  has_many :responses

  # validates :email, format: { with: /\b[A-Z0-9._%a-z\-]+@tocafootball\.com\z/, message: "Please use your TOCA email address to register." }

  def full_name
    "#{first_name} #{last_name}"
  end


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
