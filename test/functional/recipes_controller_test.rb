# encoding: utf-8
require 'test_helper'

class RecipesControllerTest < ActionController::TestCase
  
  setup do
    @betty = Cook.create! username: "bettycrocker", email: "betty@crocker.com", password: "password", password_confirmation: "password"
    @julia = Cook.create! username: "juliachilds", email: "julia@childs.com", password: "woot", password_confirmation: "woot"
    @chocolate = @julia.cookbooks.create! name: "Du Chocolate!"
    @potsdecreme = @chocolate.recipes.create! cook: @julia, name: "Chocolate Pots De Crème", category: "dessert", 
                                              ingredients: "Chocolate, Sugar, Cream", directions: "Mix and bake"
                                              
    @request.env["User-Agent"] = "Recipes Android"
    @request.env["Content-Type"] = "application/json"
    auth_key_header @julia.auth_key
  end
  
  test "GET to index should return recipes belonging to a particular user" do
    desserts = @betty.cookbooks.create! name: "Desserts"
    pecanpie = desserts.recipes.create! cook: @betty, name: "Pecan Pie", ingredients: "pecans, sugar, shortening", directions: "mix ingredients and bake"
    
    get :index, {cook_id: @julia, cookbook_id: -1, format: "json"}
    body = JSON.parse(@response.body)
    
    assert_response :success
    assert_equal 1, body.size
    assert_equal body.first["name"], @potsdecreme.name
    assert_equal body.first["ingredients"], @potsdecreme.ingredients
    assert_equal body.first["directions"], @potsdecreme.directions
    assert_not_nil body.first["updated_at"]
    assert_equal body.first["submitted_by"], @julia.username
    assert_equal body.first["cookbook"], @chocolate.name
  end

  test "POST to create should create a recipe" do
    assert_difference('Recipe.count') do
      post :create, {cook_id: @julia, cookbook_id: @chocolate, recipe: { name: "Chocolate Mousse", ingredients: "chocolate", directions: "mix ingredients" }, format: "json"}
    end

    assert_response :created
    assert_equal @response.location, cook_cookbook_recipe_url(@julia, @chocolate, assigns(:recipe))
  end

  test "GET to show should show recipe" do
    get :show, {:id => @potsdecreme, cookbook_id: @chocolate, cook_id: @julia, format: "json"}
    body = JSON.parse(@response.body)
    
    assert_response :success
    assert_equal body["name"], @potsdecreme.name
    assert_equal body["category"], @potsdecreme.category
    assert_equal body["ingredients"], @potsdecreme.ingredients
    assert_equal body["directions"], @potsdecreme.directions
  end

  test "PUT to update should update recipe" do
    put :update, {id: @potsdecreme, cookbook_id: @chocolate, cook_id: @julia, recipe: { directions: "Mix and bake at 350 degrees for 30 minutes" }, format: "json"}
    
    assert_response :no_content
    assert_equal @potsdecreme.reload.directions,  "Mix and bake at 350 degrees for 30 minutes"
  end

  test "DELETE to destroy should destroy recipe" do
    assert_difference('Recipe.count', -1) do
      delete :destroy, {id: @potsdecreme, cook_id: @julia, cookbook_id: @chocolate, format: "json"}
    end

    assert_response :no_content
  end
  
end
