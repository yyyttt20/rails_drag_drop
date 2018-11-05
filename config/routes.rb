Rails.application.routes.draw do
  resources :fileuploads
  resources :items
  # match 'fileuploads/upload'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  match ':controller(/:action(/:id(.:format)))', :via => [:get, :post]
end
