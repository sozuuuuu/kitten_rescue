require "application_system_test_case"

class DealsTest < ApplicationSystemTestCase
  setup do
    @deal = deals(:one)
  end

  test "visiting the index" do
    visit deals_url
    assert_selector "h1", text: "Deals"
  end

  test "creating a Deal" do
    visit deals_url
    click_on "New Deal"

    fill_in "Adoption request", with: @deal.adoption_request_id
    fill_in "Kitten request", with: @deal.kitten_request_id
    fill_in "State", with: @deal.state
    click_on "Create Deal"

    assert_text "Deal was successfully created"
    click_on "Back"
  end

  test "updating a Deal" do
    visit deals_url
    click_on "Edit", match: :first

    fill_in "Adoption request", with: @deal.adoption_request_id
    fill_in "Kitten request", with: @deal.kitten_request_id
    fill_in "State", with: @deal.state
    click_on "Update Deal"

    assert_text "Deal was successfully updated"
    click_on "Back"
  end

  test "destroying a Deal" do
    visit deals_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Deal was successfully destroyed"
  end
end
