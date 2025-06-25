# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.new(name: 'example', email: 'user@example.com',
                     password: 'zzZ111', password_confirmation: 'zzZ111')
  end

  test 'should get new' do
    assert @user.valid?
  end

  test 'invalid with wrong format name edge cases' do
    invalid_names = [
      'a' * 51,
      '    '
    ]
    invalid_names.each do |name|
      @user.name = name
      assert_not @user.valid?
    end
  end

  test 'invalid with wrong format email edge cases' do
    invalid_emails = [
      '      ',
      "#{'a' * 244}@example.com",
      'user@.com',
      '@example.com',
      'user@example.',
      'user@-example.com'
    ]
    invalid_emails.each do |email|
      @user.email = email
      assert_not @user.valid?
    end
  end

  test 'invalid with wrong format password edge cases' do
    invalid_passwords = [
      '         ',
      'aZ1',
      'aZ1' * 17,
      'a' * 6,
      'A' * 6,
      '1' * 6,
      'aA' * 3,
      'a1' * 3,
      'A1' * 3
    ]
    invalid_passwords.each do |password|
      @user.password = @user.password_confirmation = password
      assert_not @user.valid?
    end
  end

  test 'invalid with duplicate email' do
    @other = User.new(
      name: @user.name,
      email: @user.email,
      password: 'zzZ111',
      password_confirmation: 'zzZ111'
    )
    assert @user.save
    assert_not @other.valid?
  end

  test 'email should be saved with downcase format' do
    email = 'UsEr@ExamPle.Com'
    @user = User.create(name: 'example', email: email,
                        password: 'zzZ111', password_confirmation: 'zzZ111')
    assert_equal @user.email, email.downcase
  end
end
