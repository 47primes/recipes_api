require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  
  setup do
    @cook = Cook.create!(username: "testing", email: "test@test.com", password: "test", password_confirmation: "test")
    @request.env["User-Agent"] = "Recipes Android"
    @request.env["Content-Type"] = "application/json"
  end
  
  test "Signing in should return the auth_key in the response" do
    @request.env["HTTP_AUTHORIZATION"] = "Basic #{Base64::encode64("#{@cook.username}:#{@cook.password}")}"
    post :create, {format: "json"}
    body = JSON.parse(@response.body)
    
    assert_response :success
    assert_equal @response.location, cook_url(@cook)
    assert_equal body["auth_key"], @cook.auth_key
  end
  
  test "Signing in with an invalid username should return an error message in the response" do
    @request.env["HTTP_AUTHORIZATION"] = "Basic #{Base64::encode64("invalid:#{@cook.password}")}"
    post :create, {format: "json"}
    body = JSON.parse(@response.body)
    
    # assert_response :unprocessible_entity
    assert_not_nil body["failed"]
  end
  
  test "Signing in with a wrong password should return an error message in the response" do
    @request.env["HTTP_AUTHORIZATION"] = "Basic #{Base64::encode64("#{@cook.username}:wrong")}"
    post :create, {format: "json"}
    body = JSON.parse(@response.body)
    
    # assert_response :unprocessible_entity
    assert_not_nil body["failed"]
  end

end
