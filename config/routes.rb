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

<<<<<<< HEAD
  concern :commentable do
    resources :comments, only: :create
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, only: [:new, :create, :update, :destroy], concerns: [:votable, :commentable], shallow: true do
=======
  resources :questions, concerns: :votable do
    resources :answers, only: [:new, :create, :update, :destroy], concerns: :votable, shallow: true do
>>>>>>> 1b85e5a1b3adf3e0c06fbe0cafa926989c608a61
      patch :set_best, on: :member
    end
  end

  resources :attachments, only: [:destroy]

  mount ActionCable.server => '/cable'
end
