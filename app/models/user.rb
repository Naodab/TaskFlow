# frozen_string_literal: true

class User < ApplicationRecord
  # Password has at least one letter, one upcase letter, one digest
  VALID_PASSWORD_REGEX = /\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d).+\z/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@([a-z\d]+(-[a-z\d]+)*\.)+[a-z]+\z/i

  before_save :downcase_email

  validates :name, presence: true, length: { maximum: 50 }
  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: true
  validates :password,
            presence: true,
            length: { minimum: 6, maximum: 50 },
            format: { with: VALID_PASSWORD_REGEX }

  has_secure_password

  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
