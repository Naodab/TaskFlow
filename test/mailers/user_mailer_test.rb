# frozen_string_literal: true

require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  def prepare_token(token_type)
    @user = users(:one)
    token = User.new_token
    @user.send("#{token_type}_token=", token)
    token
  end

  def assert_user_mail(token_type, mailer_method, subject_text)
    token = prepare_token(token_type)
    mail = UserMailer.send(mailer_method, @user)

    assert_equal subject_text, mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ['from@example.com'], mail.from
    assert_match token, mail.body.encoded
    assert_match CGI.escape(@user.email), mail.body.encoded
    mail
  end

  test 'account_activation' do
    mail = assert_user_mail(:activation, :activate_account, 'Activate account')
    assert_match @user.name, mail.body.encoded
  end
end
