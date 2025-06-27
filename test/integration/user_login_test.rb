# frozen_string_literal: true

require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test 'should not login with invalid email' do
    get login_path
    post login_path, params: {
      session: {
        email: '',
        password: 'zzZ111'
      }
    }
    assert_not flash.now[:danger].nil?
  end

  test 'should login with valid information' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: {
      session: {
        email: @user.email,
        password: 'zzZ111'
      }
    }
    assert_not flash.empty?
  end

  test 'should set cookies remember_token with remembering login' do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies[:remember_token]
  end

  test 'should not set cookies remember_token without remembering login' do
    log_in_as(@user, remember_me: '1')
    log_in_as(@user, remember_me: '0')
    assert_empty cookies[:remember_token]
  end
end
