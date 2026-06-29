Rails.application.routes.draw do
  get "customers/clients/:customer_id", to: "customers/clients#index"
  get "clients/customers/:client_id", to: "clients/customers#index"

  resources :customers, except: [ :destroy ]
  resources :clients, except: [ :destroy ]
  resources :client_customers, except: [ :destroy, :index ]

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
