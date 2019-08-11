require "application_system_test_case"

class TestimonialsTest < ApplicationSystemTestCase
  setup do
    @testimonial = testimonials(:one)
  end

  test "visiting the index" do
    visit testimonials_url
    assert_selector "h1", text: "Testimonials"
  end

  test "creating a Testimonial" do
    visit testimonials_url
    click_on "New Testimonial"

    check "Approved" if @testimonial.approved
    fill_in "Body", with: @testimonial.body
    fill_in "Category", with: @testimonial.category
    check "Featured" if @testimonial.featured
    fill_in "Title", with: @testimonial.title
    fill_in "User", with: @testimonial.user_id
    click_on "Create Testimonial"

    assert_text "Testimonial was successfully created"
    click_on "Back"
  end

  test "updating a Testimonial" do
    visit testimonials_url
    click_on "Edit", match: :first

    check "Approved" if @testimonial.approved
    fill_in "Body", with: @testimonial.body
    fill_in "Category", with: @testimonial.category
    check "Featured" if @testimonial.featured
    fill_in "Title", with: @testimonial.title
    fill_in "User", with: @testimonial.user_id
    click_on "Update Testimonial"

    assert_text "Testimonial was successfully updated"
    click_on "Back"
  end

  test "destroying a Testimonial" do
    visit testimonials_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Testimonial was successfully destroyed"
  end
end
