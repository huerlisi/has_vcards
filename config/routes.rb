# Routes
HasVcards::Engine.routes.draw do
  # Phone Numbers
  resources :phone_numbers

  # Vcards
  resources :vcards do
    resources :phone_numbers

    # DirectoryLookup
    member do
      get :directory_lookup
      post :directory_update
    end
  end

  # Directory Lookup
  get 'directory_lookup/search' => 'directory_lookup#search'
end
