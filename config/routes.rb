require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }

  as :user do
    get 'signup_email', to: 'users/registrations#edit_email', as: :edit_signup_email
    post 'signup_email', to: 'users/registrations#update_email', as: :update_signup_email
  end

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
        get :index, on: :collection
      end
      resources :questions do
        resources :answers, shallow: true
      end
    end
  end

  root 'questions#index'

  concern :votable do
    member do
      post :like
      post :dislike
      patch :change_vote
      delete :cancel_vote
    end
  end

  concern :commentable do
    resources :comments, only: :create
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, only: [:new, :create, :update, :destroy], concerns: [:votable, :commentable], shallow: true do
      patch :set_best, on: :member
    end
  end

  resources :attachments, only: [:destroy]

  mount ActionCable.server => '/cable'
end
