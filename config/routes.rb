Rails.application.routes.draw do
  get 'about' => 'static#about', as: :about

  resources :universities do
  	resources :surveys
    member do
      put 'data', action: :update_data
      get 'analyze', action: :analyze_data
    end
  end

  namespace :wechat do
    get '/' => "secret#token"

    get 'jsToken' => "secret#jsSDK"
    get 'sign' => 'secret#sign'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
