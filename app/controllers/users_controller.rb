# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      @user.send_activation_email
      flash[:success] = 'The activation link has been sent to your email.'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show; end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'User not found'
    redirect_to root_url
  end
end
