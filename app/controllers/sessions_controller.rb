class SessionsController < ApplicationController
  
  def create
    if cook = authenticate_with_http_basic { |username, password| cook = Cook.find_by_username(username) and cook.authenticate(password) }
      render json: {auth_key: cook.auth_key}, status: :ok, :location => cook_url(cook)
		else
		  render json: {failed: "invalid username/password"}, status: :unprocessible_entity
	  end
  end
  
end
