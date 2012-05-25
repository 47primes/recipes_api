class CookbooksController < ApplicationController
  before_filter :validate_auth_key
  
  def index
    @cookbooks = @cook.cookbooks
  end
  
  def create
    @cookbook = @cook.cookbooks.new(params[:cookbook])
    
    if @cookbook.save
      head(:created, :location => [@cook, @cookbook])
    else
      render json: {:error => @cookbook.errors}, status: :unprocessable_entity
    end
  end

  def show
    @cookbook = @cook.cookbooks.find(params[:id])
  end

  def update
    @cookbook = @cook.cookbooks.find(params[:id])
    
    if @cookbook.update_attributes(params[:cookbook])
      head(:no_content)
    else
      render json: {:error => @cookbook.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @cookbook = Cookbook.find(params[:id])
    
    if @cookbook.destroy
      head(:no_content)
    else
      render json: {:error => @cookbook.errors}, status: :unprocessable_entity
    end
  end
end
