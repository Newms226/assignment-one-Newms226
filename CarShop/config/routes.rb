Rails.application.routes.draw do
  resources :makes do
    get :autocomplete_make_name, on: :collection
    # get :autocomplete_make_country, on: :collection
    
    collection do
      get 'search'
    end
  end


  resources :parts

  resources :cars do
    collection do
      get 'search'
    end

    # get :autocomplete_car_vin, on: :collection

  end



  # resources :cars do
  #   resources :parts
  # end



  # changing the root web page!
  root to: 'cars#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
