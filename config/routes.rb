Rails.application.routes.draw do
  resources :customers, only: [ :index, :show, :update ]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

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
