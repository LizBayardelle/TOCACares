Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'

  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :users, only: [:show, :index]

  resources :hardships
  post "hardships/:id/withdraw_hardship" => "hardships#withdraw_hardship", as: "withdraw_hardship"
  post "hardships/:id/approve_hardship" => "hardships#approve_hardship", as: "approve_hardship"
  post "hardships/:id/reject_hardship" => "hardships#reject_hardship", as: "reject_hardship"

  resources :charities
  post "charities/:id/withdraw_charity" => "charities#withdraw_charity", as: "withdraw_charity"
  post "charities/:id/approve_charity" => "charities#approve_charity", as: "approve_charity"
  post "charities/:id/reject_charity" => "charities#reject_charity", as: "reject_charity"

  resources :scholarships
  post "scholarships/:id/withdraw_scholarship" => "scholarships#withdraw_scholarship", as: "withdraw_scholarship"
  post "scholarships/:id/approve_scholarship" => "scholarships#approve_scholarship", as: "approve_scholarship"
  post "scholarships/:id/reject_scholarship" => "scholarships#reject_scholarship", as: "reject_scholarship"


end
