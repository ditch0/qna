require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper
  root to: 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    post '/users/auth/proceed_with_email', to: 'omniauth_callbacks#proceed_with_email'
  end

  concern :votable do
    post :vote_up, :vote_down, :reset_vote, on: :member
  end

  concern :commentable do
    resources :comments, shallow: true, only: [:create]
  end

  resources :questions, only: [:new, :create, :index, :show, :destroy, :update] do
    concerns [:votable, :commentable]
    post :follow, :unsubscribe, on: :member
    resources :answers, shallow: true, only: [:new, :create, :destroy, :update] do
      concerns [:votable, :commentable]
      post :set_is_best, on: :member
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, only: [:index, :show, :create] do
        resources :answers, shallow: true, only: [:index, :show, :create]
      end
    end
  end

  mount ActionCable.server => '/cable'
  mount Sidekiq::Web => '/sidekiq'
end
