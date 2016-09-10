Rails.application.routes.draw do
  get 'static/about', as: :about

  resources :universities do
  	resources :surveys
    member do
      put 'data', action: :update_data
      get 'analyze', action: :analyze_data
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
