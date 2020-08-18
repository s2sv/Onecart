require 'test_helper'

class CancelledControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get cancelled_show_url
    assert_response :success
  end

end
