Rails.application.routes.draw do
  resources :questions, only: [:new, :create, :index, :show]
end
