require 'test_helper'

class SuccesfulControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get succesful_show_url
    assert_response :success
  end

  test "should get update" do
    get succesful_update_url
    assert_response :success
  end

end
