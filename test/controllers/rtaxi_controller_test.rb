require "test_helper"

class RtaxiControllerTest < ActionDispatch::IntegrationTest
  test "should get wait" do
    get rtaxi_wait_url
    assert_response :success
  end
end
