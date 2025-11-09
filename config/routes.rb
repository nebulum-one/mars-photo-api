Rails.application.routes.draw do
  root to: 'static#explore'
  
  namespace :api do
    namespace :v1 do
      # ... existing routes ...
    end
  end
  
  # ADD THIS LINE:
  post 'admin/trigger_scrapers', to: 'admin#trigger_scrapers'
end
