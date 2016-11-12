Rails.application.routes.draw do
  resources :questions, only: [:new, :create, :index, :show] do
    resources :answers, only: [:new, :create]
  end
end
