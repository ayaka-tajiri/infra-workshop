Rails.application.routes.draw do
  scope :api do
    resources :todos do
      resources :todo_lists
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
