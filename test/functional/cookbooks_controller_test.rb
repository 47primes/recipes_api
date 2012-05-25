require 'test_helper'

class CookbooksControllerTest < ActionController::TestCase
  setup do
    @betty = Cook.create! username: "bettycrocker", email: "betty@crocker.com", password: "password", password_confirmation: "password"    
    @julia = Cook.create! username: "juliachilds", email: "julia@childs.com", password: "woot", password_confirmation: "woot"
    
    @request.env["User-Agent"] = "Recipes Android"
    @request.env["Content-Type"] = "application/json"
    auth_key_header @julia.auth_key
  end

  test "GET to index should return cookbooks belonging to a particular user" do
    desserts = @betty.cookbooks.create! name: "Desserts"
    pecanpie = desserts.recipes.create! cook: @betty, name: "Pecan Pie", ingredients: "pecans, sugar, shortening", directions: "mix ingredients and bake"
    
    chocolate = @julia.cookbooks.create! name: "Du Chocolate!"
    
    auth_key_header @betty.auth_key
    
    get :index, {cook_id: @betty, format: "json"}
    body = JSON.parse(@response.body)
    
    assert_response :success
    assert_equal 1, body.size
    
    assert_equal body.first["name"], desserts.name
    assert_equal body.first["recipes"].size, desserts.recipes.count
    
    assert_equal body.first["recipes"].first["name"], pecanpie.name
    assert_equal body.first["recipes"].first["ingredients"], pecanpie.ingredients
    assert_equal body.first["recipes"].first["directions"], pecanpie.directions
    assert_nil body.first["recipes"].first["category"]
  end

  test "POST to create should create cookbook" do
    assert_difference('Cookbook.count') do
      post :create, {cook_id: @julia, :cookbook => { name: "Des Aperitifs" }, format: "json"}
    end

    assert_response :created
    assert_equal @response.location, cook_cookbook_url(@julia, assigns(:cookbook))
  end

  test "GET to show should show cookbook" do
    cookbook = @julia.cookbooks.create! name: "Le Frommage", description: "Des plats pricipaux qui ont pour leur ingredient premier le frommage"
    
    get :show, {:id => cookbook, cook_id: @julia, format: "json"}
    body = JSON.parse(@response.body)
    
    assert_response :success
    assert_equal body["name"], cookbook.name
    assert_equal body["description"], cookbook.description
  end

  test "PUT to update should update cookbook" do
    cookbook = @betty.cookbooks.create! name: "Chocolates", description: "Chocolates of all types"
    
    auth_key_header @betty.auth_key
    
    put :update, {id: cookbook, cook_id: @betty, cookbook: { description: "Chocolates of all types and sweetness" }, format: "json"}
    
    assert_response :no_content
    assert_equal cookbook.reload.description,  "Chocolates of all types and sweetness"
  end

  test "DELETE to destroy should destroy cookbook" do
    cookbook = @julia.cookbooks.create! name: "Des Salads"
    
    assert_difference('Cookbook.count', -1) do
      delete :destroy, {id: cookbook, cook_id: @julia, format: "json"}
    end

    assert_response :no_content
  end
end
