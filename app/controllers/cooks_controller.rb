class CooksController < ApplicationController
  before_filter :validate_auth_key, :only => :update

  def create
    @cook = Cook.new(params[:cook])
    
    if @cook.save
      head(:created, :location => cook_url(@cook))
    else
      render json: {:error => @cook.errors}, status: :unprocessable_entity
    end
  end

  def update
    if @cook.update_attributes(params[:cook])
      head(:no_content)
    else
      render json: {:error => @cook.errors}, status: :unprocessable_entity
    end
  end

end
