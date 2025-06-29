# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/activate_account
  def activate_account
    user = User.first
    user.activation_token = User.new_token
    UserMailer.activate_account user
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/reset_password
  def reset_password
    user = User.first
    user.create_reset_digest
    UserMailer.reset_password user
  end
end
