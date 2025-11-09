Rails.application.routes.draw do
  root 'static#explore'

  get '/explore(/*whatevs)' => 'static#explore', as: :explore

  namespace :api do
    namespace :v1 do
      # ✅ Existing routes
      resources :rovers, only: [:show, :index] do
        resources :photos, only: :index
        resources :latest_photos, only: :index
      end
      resources :photos, only: :show
      resources :manifests, only: :show

      # ✅ Line for your refresh endpoint:
      post 'refresh', to: 'refresh#create'
    end
  end
end
