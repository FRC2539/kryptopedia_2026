Rails.application.routes.draw do
  get "pages/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#index"

  get "webhooks" => "incoming_webhooks#index"
  post "webhooks/tba" => "incoming_webhooks#tba"

  resources :teams, path: "", param: :number do
    get "/" => "teams#home_feed", as: :home_feed
    get "login" => "teams#login", as: :login
    post "login" => "teams#send_login_code", as: :send_login_code
    get "login/verify_code" => "teams#verify_login_code", as: :verify_login_code
    post "login/verify_code" => "teams#process_login_code", as: :process_login_code
    get :logout

    post "session-requests/:id/approve" => "session_requests#approve", as: :approve_session_request
    delete "session-requests/:id" => "session_requests#destroy", as: :destroy_session_request

    resources :scouted_events do
      resources :matches
      post "matches/download-from-tba" => "matches#download_matches_from_tba", as: :download_matches_from_tba
      get "teams" => "scouted_events#index_teams", as: :teams
      post "teams/download-from-tba" => "scouted_events#download_teams", as: :download_teams_from_tba
      resources :scouting_data_items, param: :uid do
        post "restore" => "scouting_data_items#restore", as: :restore
      end
      resources :preloaded_flags
    end

    resources :team_members
    resources :devices

    get "api/preauth-info" => "device_api#preauth_info"
    post "api/start-session" => "device_api#request_session"
    post "api/cancel-session-request" => "device_api#cancel_session_request"
    get "api/poke-session" => "device_api#check_session_request"
    get "api/me" => "device_api#me"
    post "api/sync" => "device_api#sync"
    post "api/photos/:uid" => "device_api#upload_scouting_data_item_photo"
    get "api/photos/:uid" => "device_api#download_scouting_data_item_photo"
  end
end
