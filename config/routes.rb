Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users, path: "", controllers: {
        sessions: "api/v1/users/sessions"
      }

      get "/users/:user_id/addresses", to: "addresses#find_by_cep", constraints: { cep: /[0-9]{8}/ }
    end
  end
end
