# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  before_action :set_user, only: %i[edit update]
  before_action :valid_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email])
    if @user&.activated?
      @user.create_reset_digest
      @user.send_password_reset_email
    end
    flash[:info] = 'If your email is registered, you will receive a password reset email shortly.'
    redirect_to root_url
  end

  def edit; end

  def update
    if @user.update(user_params)
      @user.forget(:reset)
      flash[:success] = 'Password has been reset successfully.'
      log_in @user
      redirect_to @user
    else
      flash.now[:danger] = 'Failed to reset password. Please try again.'
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def set_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    return if @user&.activated? && @user.authenticate?(:reset, params[:id])

    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = 'Password reset link has expired.'
    redirect_to new_password_reset_url
  end
end
