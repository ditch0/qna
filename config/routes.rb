Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, only: [:new, :create, :index, :show, :destroy] do
    resources :answers, only: [:new, :create]
  end
end
