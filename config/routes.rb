Rails.application.routes.draw do
  devise_for :users

  root 'questions#index'

  resources :questions do
    resources :answers, only: [:new, :create, :update, :destroy], shallow: true do
      patch :set_best, on: :member
    end
  end

  resources :attachments, only: [:destroy]
end
