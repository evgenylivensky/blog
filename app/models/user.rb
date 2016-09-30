class User < ApplicationRecord
  validates_presence_of :email

  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :email, length: 5..255
  validates :email, uniqueness: { case_sensitive: false }

  validates :password, confirmation: true
  validates :password, length: { minimum: 6 }

  devise :database_authenticatable,
         :registerable
end
