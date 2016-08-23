Rails.application.routes.draw do

  resources :dims

  resources :pres

  resources :focals

  resources :cases do
    get 'claim', on: :member
    get 'claimHypo', on: :member
  end


  root to: 'visitors#index'
  devise_for :users
  resources :users
end
