class Player < ApplicationRecord
  has_secure_password
  validates :username, uniqueness: true
  # validates :password, length: { minimum: 8 }
end
