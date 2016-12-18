Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    post :vote_up, :vote_down, :reset_vote, on: :member
  end

  concern :commentable do
    resources :comments, shallow: true, only: [:create]
  end

  resources :questions, only: [:new, :create, :index, :show, :destroy, :update] do
    concerns [:votable, :commentable]
    resources :answers, shallow: true, only: [:new, :create, :show, :destroy, :update] do
      concerns [:votable, :commentable]
      post :set_is_best, on: :member
    end
  end

  mount ActionCable.server => '/cable'
end
