# frozen_string_literal: true

require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.new(name: 'Example User', email: 'user@example.com',
                     password: 'zzZ111', password_confirmation: 'zzZ111')
  end

  test 'should not register user' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: {
        name: '',
        email: 'user@invalid',
        password: 'foo',
        password_confirmation: 'bar'
      } }
    end
    assert_template 'users/new'
  end

  test 'should register user' do
    get signup_url
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: {
          name: @user.name,
          email: @user.email,
          password: @user.password,
          password_confirmation: @user.password_confirmation
        }
      }
    end
  end
end
