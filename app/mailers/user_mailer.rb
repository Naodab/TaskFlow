# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def activate_account(user)
    @user = user
    mail to: @user.email, subject: 'Activate account'
  end

  def reset_password(user)
    @user = user

    mail to: @user.email, subject: 'Password reset'
  end
end
