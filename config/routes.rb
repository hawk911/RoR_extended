Rails.application.routes.draw do
  devise_for :users

  root 'questions#index'

  concern :votable do
    member do
      post :like
      post :dislike
      patch :change_vote
      delete :cancel_vote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, only: [:new, :create, :update, :destroy], concerns: :votable, shallow: true do
      patch :set_best, on: :member
    end
  end

  resources :attachments, only: [:destroy]

mount ActionCable.server => '/cable'
end
