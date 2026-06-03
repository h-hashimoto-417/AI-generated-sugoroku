class User < ApplicationRecord
  has_secure_password

  validates :uname, presence: true, uniqueness: true
end