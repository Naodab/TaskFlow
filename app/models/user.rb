# frozen_string_literal: true

class User < ApplicationRecord
  # Password has at least one letter, one upcase letter, one digest
  VALID_PASSWORD_REGEX = /\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d).+\z/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@([a-z\d]+(-[a-z\d]+)*\.)+[a-z]+\z/i
  PASSWORD_RESET_EXPIRATION_TIME = 2.hours

  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  before_create :create_activation_token

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

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget(attribute)
    update_attribute("#{attribute}_digest", nil)
  end

  def authenticate?(attribute, token)
    digest = send("#{attribute}_digest")
    digest.nil? ? false : BCrypt::Password.new(digest).is_password?(token)
  end

  def activate_account
    update_columns(activated: true, activation_digest: nil)
  end

  def send_activation_email
    UserMailer.activate_account(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.reset_password(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < PASSWORD_RESET_EXPIRATION_TIME.ago
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_token
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
