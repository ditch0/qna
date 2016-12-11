Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    post :vote_up, :vote_down, :reset_vote, on: :member
  end

  resources :questions, only: [:new, :create, :index, :show, :destroy, :update] do
    concerns :votable
    resources :answers, shallow: true, only: [:new, :create, :destroy, :update] do
      concerns :votable
      post :set_is_best, on: :member
    end
  end
end
