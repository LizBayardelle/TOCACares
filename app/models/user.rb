class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :charities, dependent: :destroy
  has_many :hardships, dependent: :destroy
  has_many :scholarships, dependent: :destroy
  has_many :testimonials, dependent: :destroy
  has_many :logs, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :responses, dependent: :destroy
  has_many :app_forms, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :variations

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
