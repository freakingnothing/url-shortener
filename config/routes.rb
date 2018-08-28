Rails.application.routes.draw do
  resources :urls, only: :create

  get '/:short_url', to: 'urls#redirect_to_original_url'
  get 'view/:short_url', to: 'urls#view', as: :view

  root 'urls#new'
end
