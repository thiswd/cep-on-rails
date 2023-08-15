Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users, path: '', controllers: {
        sessions: "api/v1/users/sessions"
      }
    end
  end
end
