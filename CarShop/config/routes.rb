Rails.application.routes.draw do
  resources :makes
  resources :parts

  resources :cars do
    collection do
      get 'search'
    end
  end

  # resources :cars do
  #   resources :parts
  # end



  # changing the root web page!
  root to: 'cars#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
