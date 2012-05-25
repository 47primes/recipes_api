require 'test_helper'

class WidgetsController < ApplicationController
  before_filter :validate_auth_key, only: "index"
  
  def index
    head(:no_content)
  end
  
  def create
    head(:no_content)
  end
  
  def show
    head(:no_content)
  end
  
  def update
    raise "Khaaaan!"
    head(:no_content)
  end
  
end

class ApplicationControllerTest < ActionController::TestCase
  
  setup do
    @controller = WidgetsController.new
    RecipesApi::Application.routes.disable_clear_and_finalize = true
    RecipesApi::Application.routes.draw { resources :widgets, constraints: {format: "json"} }
  end
  
  test "a request should fail with an invalid user agent header" do
    get :index, {format: "json"}
    
    assert_response :bad_request
  end
  
  test "a post should fail with the incorrect content type header" do
    @request.env["User-Agent"] = "Recipes Android"
    @request.env["Content-Type"] = "text/xml"
    
    post :create, {format: "json"}
    
    assert_response :unsupported_media_type
  end
  
  test "response should set content type" do
    @request.env["User-Agent"] = "Recipes Android"
    @request.env["Content-Type"] = "application/json"
    
    get :show, {id: 1, format: "json"}
    
    assert_response :no_content
    assert_equal @response.content_type, "application/json"
  end
  
  test "response to the wrong format" do
    @request.env["User-Agent"] = "Recipes Android"
    @request.env["Content-Type"] = "application/json"
    
    get :show, {id: 1, format: "html"}
    
    assert_response :unsupported_media_type
  end
  
  test "should validate authentication key" do
    @request.env["User-Agent"] = "Recipes Android"
    @request.env["Content-Type"] = "application/json"
    @request.env[ApplicationController::AUTH_KEY_HEADER_KEY] = "12345"
    
    get :index, {format: "json"}
    
    assert_response :unauthorized
  end
  
  test "should respond to failures with JSON" do
    @request.env["User-Agent"] = "Recipes Android"
    @request.env["Content-Type"] = "application/json"
    
    post :update, {id: 1, format: "json"}
    body = JSON.parse(@response.body)
    
    assert_response :internal_server_error
    assert_equal body["error"], "A problem has occurred."
  end
  
end
