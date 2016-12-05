Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, only: [:new, :create, :index, :show, :destroy, :update] do
    resources :answers, shallow: true, only: [:new, :create, :destroy, :update] do
      post :set_is_best, on: :member
    end
  end
end
