require 'test_helper'

class CooksControllerTest < ActionController::TestCase

  setup do
    @request.env["User-Agent"] = "Recipes Android"
    @request.env["Content-Type"] = "application/json"
  end

  test "should create cook" do
    assert_difference('Cook.count') do
      post :create, {cook: { username: "johndoe", email: "test@test.com", password: "foo", password_confirmation: "foo" }, format: "json"}
    end

    assert_response :created
    assert_equal @response.location, cook_url(assigns(:cook))
  end

  test "should update cook" do
    cook = Cook.create! username: "johndoe", email: "test@test.com", password: "testing", password_confirmation: "testing"
    auth_key_header cook.auth_key
    put :update, {id: cook, cook: { password: "bar", password_confirmation: "bar" }, format: "json"}
    
    assert_response :no_content
    assert cook.reload.authenticate("bar")
  end

end
