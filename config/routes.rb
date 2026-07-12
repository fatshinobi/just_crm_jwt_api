Rails.application.routes.draw do
  get "customers/clients/:customer_id", to: "customers/clients#index"
  get "clients/customers/:client_id", to: "clients/customers#index"
  get "roles/:start_str", to: "roles#index"

  resources :customers, except: [ :destroy ] do
    member do
      resources :tags, only: [ :create, :index ], module: :customers
    end
  end

  resources :clients, except: [ :destroy ] do
    member do
      resources :tags, only: [ :create, :index ], module: :clients
    end
  end

  resources :client_customers, except: [ :destroy, :index ]
  resources :customer_tags, only: [ :index ]
  resources :client_tags, only: [ :index ]

  namespace :catalogs do
    get "users"
    get "clients_by_customer/:customer_id", to: "clients_by_customer"
    get "customers_by_client/:client_id", to: "customers_by_client"
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
