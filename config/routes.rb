# Routes
Rails.application.routes.draw do
  # Phone Numbers
  resources :phone_numbers

  # Vcards
  resources :vcards do
    resources :phone_numbers
  end
end
