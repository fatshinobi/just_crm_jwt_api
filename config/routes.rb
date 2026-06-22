Rails.application.routes.draw do
  resources :customers, except: [ :destroy ]
  resources :clients, except: [ :destroy ]

  namespace :catalogs do
    get "users"
  end

  devise_for :users,
    path: "",
    path_names: {
      sign_in: "login",
      sign_out: "logout",
      registration: "signup"
    },
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations"
    }
end
