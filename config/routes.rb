Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'
  get 'home/pending'

  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :users, only: [:show, :index]
  post "users/:id/make_admin" => "users#make_admin", as: "make_admin"
  post "users/:id/make_committee" => "users#make_committee", as: "make_committee"
  post "users/:id/remove_admin" => "users#remove_admin", as: "remove_admin"
  post "users/:id/remove_committee" => "users#remove_committee", as: "remove_committee"
  post "users/:id/committee_request" => "users#committee_request", as: "committee_request"
  post "users/:id/deny_committee" => "users#deny_committee", as: "deny_committee"

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
