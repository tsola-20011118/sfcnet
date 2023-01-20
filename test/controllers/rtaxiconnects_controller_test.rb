require "test_helper"

class RtaxiconnectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rtaxiconnect = rtaxiconnects(:one)
  end

  test "should get index" do
    get rtaxiconnects_url
    assert_response :success
  end

  test "should get new" do
    get new_rtaxiconnect_url
    assert_response :success
  end

  test "should create rtaxiconnect" do
    assert_difference("Rtaxiconnect.count") do
      post rtaxiconnects_url, params: { rtaxiconnect: { from: @rtaxiconnect.from, to: @rtaxiconnect.to } }
    end

    assert_redirected_to rtaxiconnect_url(Rtaxiconnect.last)
  end

  test "should show rtaxiconnect" do
    get rtaxiconnect_url(@rtaxiconnect)
    assert_response :success
  end

  test "should get edit" do
    get edit_rtaxiconnect_url(@rtaxiconnect)
    assert_response :success
  end

  test "should update rtaxiconnect" do
    patch rtaxiconnect_url(@rtaxiconnect), params: { rtaxiconnect: { from: @rtaxiconnect.from, to: @rtaxiconnect.to } }
    assert_redirected_to rtaxiconnect_url(@rtaxiconnect)
  end

  test "should destroy rtaxiconnect" do
    assert_difference("Rtaxiconnect.count", -1) do
      delete rtaxiconnect_url(@rtaxiconnect)
    end

    assert_redirected_to rtaxiconnects_url
  end
end
