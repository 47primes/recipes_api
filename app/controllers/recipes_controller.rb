class RecipesController < ApplicationController
  before_filter :validate_auth_key
  before_filter :get_cookbook
  
  def index
    @recipes = @cookbook ? @cookbook.recipes : @cook.recipes
  end
  
  def create
    @recipe = @cook.recipes.new(params[:recipe])
    @recipe.cookbook = @cookbook
    
    if @recipe.save
      head(:created, :location => [@cook, @cookbook, @recipe])
    else
      render json: {:error => @recipe.errors}, status: :unprocessable_entity
    end
  end

  def show
    @recipe = @cook.recipes.find(params[:id])
  end

  def update
    @recipe = @cook.recipes.find(params[:id])
    
    if @recipe.update_attributes(params[:recipe])
      head(:no_content)
    else
      render json: {:error => @recipe.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe = @cook.recipes.find(params[:id])
    
    if @recipe.destroy
      head(:no_content)
    else
      render json: {:error => @recipe.errors}, status: :unprocessable_entity
    end
  end
  
  private
  
  def get_cookbook
    @cookbook = @cook.cookbooks.find_by_id(params[:cookbook_id])
  end
end
