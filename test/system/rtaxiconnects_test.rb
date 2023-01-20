require "application_system_test_case"

class RtaxiconnectsTest < ApplicationSystemTestCase
  setup do
    @rtaxiconnect = rtaxiconnects(:one)
  end

  test "visiting the index" do
    visit rtaxiconnects_url
    assert_selector "h1", text: "Rtaxiconnects"
  end

  test "should create rtaxiconnect" do
    visit rtaxiconnects_url
    click_on "New rtaxiconnect"

    fill_in "From", with: @rtaxiconnect.from
    fill_in "To", with: @rtaxiconnect.to
    click_on "Create Rtaxiconnect"

    assert_text "Rtaxiconnect was successfully created"
    click_on "Back"
  end

  test "should update Rtaxiconnect" do
    visit rtaxiconnect_url(@rtaxiconnect)
    click_on "Edit this rtaxiconnect", match: :first

    fill_in "From", with: @rtaxiconnect.from
    fill_in "To", with: @rtaxiconnect.to
    click_on "Update Rtaxiconnect"

    assert_text "Rtaxiconnect was successfully updated"
    click_on "Back"
  end

  test "should destroy Rtaxiconnect" do
    visit rtaxiconnect_url(@rtaxiconnect)
    click_on "Destroy this rtaxiconnect", match: :first

    assert_text "Rtaxiconnect was successfully destroyed"
  end
end
