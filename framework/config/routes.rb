Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "/home" => "home#top"
  post "/home/generate" => "home#generate"

  get "/play/input-member" => "play#top"
  post "/play/input-member" => "play#input_member"
  get "/play" => "play#play"


  get "/signup" => "users#new"
  post "/signup" => "users#create"

  get "/login" => "sessions#new"
  post "/login" => "sessions#create"
  delete "/logout" => "sessions#destroy"
end
