Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'
  get 'home/pending'
  get 'home/testimonials'
  get 'home/applications'

  devise_for :users, :controllers => { registrations: 'registrations' }

  resources :users, only: [:show, :index]
  post "users/:id/authorize_user" => "users#authorize_user", as: "authorize_user"
  post "users/:id/unauthorize_user" => "users#unauthorize_user", as: "unauthorize_user"
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
  post "hardships/:id/close_hardship" => "hardships#close_hardship", as: "close_hardship"
  post "hardships/:id/funding_completed_hardship" => "hardships#funding_completed_hardship", as: "funding_completed_hardship"

  resources :scholarships
  post "scholarships/:id/withdraw_scholarship" => "scholarships#withdraw_scholarship", as: "withdraw_scholarship"
  post "scholarships/:id/approve_scholarship" => "scholarships#approve_scholarship", as: "approve_scholarship"
  post "scholarships/:id/reject_scholarship" => "scholarships#reject_scholarship", as: "reject_scholarship"
  post "scholarships/:id/close_scholarship" => "scholarships#close_scholarship", as: "close_scholarship"
  post "scholarships/:funding_completedose_scholarship" => "scholarships#funding_completed_cholarship", as: "funding_completed_scholarship"

  resources :charities
  post "charities/:id/withdraw_charity" => "charities#withdraw_charity", as: "withdraw_charity"
  post "charities/:id/approve_charity" => "charities#approve_charity", as: "approve_charity"
  post "charities/:id/reject_charity" => "charities#reject_charity", as: "reject_charity"
  post "charities/:id/close_charity" => "charities#close_charity", as: "close_charity"
  post "charities/:id/funding_completed_charity" => "charities#funding_completed_charity", as: "funding_completed_charity"

  resources :votes
  post "votes/:id/second_vote" => "votes#second_vote", as: "second_vote"

  resources :testimonials
  post "testimonials/:id/approve_testimonial" => "testimonials#approve_testimonial", as: "approve_testimonial"
  post "testimonials/:id/feature_testimonial" => "testimonials#feature_testimonial", as: "feature_testimonial"
  post "testimonials/:id/unfeature_testimonial" => "testimonials#unfeature_testimonial", as: "unfeature_testimonial"

  resources :authorizations

  resources :questions
  post "questions/:id/mark_answered" => "questions#mark_answered", as: "mark_answered"
  post "questions/:id/mark_unanswered" => "questions#mark_unanswered", as: "mark_unanswered"

  resources :logs

  resources :values
  post "values/:id/select_value" => "values#select_value", as: "select_value"

end
