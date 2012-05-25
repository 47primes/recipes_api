RecipesApi::Application.routes.draw do
  match "/sessions.:format" => "sessions#create", :via => :get, :as => :session, :constraints => {:format => "json"}

  resources :cooks, only: [:create, :update], constraints: {format: "json"} do
    resources :cookbooks, constraints: {format: "json"} do
      resources :recipes, constraints: {format: "json"}
    end
  end
end
