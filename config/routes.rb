Rails.application.routes.draw do
  resources :cities do
    collection do
      get 'search'
    end
  end
  resources :states
end
