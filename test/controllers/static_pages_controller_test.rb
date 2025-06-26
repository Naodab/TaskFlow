# frozen_string_literal: true

require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get home' do
    get home_static_pages_url
    assert_response :success
    assert_select 'title', full_title('Home')
  end

  test 'should get about' do
    get about_static_pages_url
    assert_response :success
    assert_select 'title', full_title('About')
  end
end
