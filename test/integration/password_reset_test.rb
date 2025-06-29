# frozen_string_literal: true

require 'test_helper'

class PasswordResetTest < ActionDispatch::IntegrationTest
  setup do
    ActionMailer::Base.deliveries.clear
    @user = users(:one)
  end

  test 'should not reset password with expired token' do
    get new_password_reset_path
    post password_resets_path, params: { password_reset: { email: @user.email } }
    @user = assigns(:user)
    @user.update(reset_sent_at: 3.hours.ago)
    patch password_reset_path(@user.reset_token),
          params: { email: @user.email,
                    user: { password: 'zzZ111',
                            password_confirmation: 'zzZ111' } }
    assert_response :redirect
    assert_not_empty flash
  end

  test 'password reset form renders correctly' do
    get new_password_reset_path
    assert_response :success
    assert_select 'form[action=?]', password_resets_path
    assert_select 'input[name=?]', 'password_reset[email]'
  end

  test 'valid email sends reset email and handles bad tokens' do
    post password_resets_path, params: { password_reset: { email: @user.email } }
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url

    user = assigns(:user)

    get edit_password_reset_path(user.reset_token, email: '')
    assert_redirected_to root_url

    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)

    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
  end
end
