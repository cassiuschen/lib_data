Rails.application.routes.draw do
  resources :universities do
    member do
      put 'data', action: :update_data
      get 'analyze', action: :analyze_data
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
