Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'

  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :users, only: [:show, :index]

  resources :hardships
  post "hardships/:id/withdraw_application" => "hardships#withdraw_application", as: "withdraw_application"

end
