Rails.application.routes.draw do
  devise_for :users

  root 'questions#index'

  resources :questions do
    resources :answers, only: [:new, :create, :update, :destroy], shallow: true
      patch :set_best, on: :member
  end
end
