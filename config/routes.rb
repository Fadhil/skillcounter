SkillCounter::Application.routes.draw do

  #devise_for :user_logins, controllers: { registrations: "sessions" }
  devise_for :users
  resources :users
  resources :events
  resources :organizers
  resources :vets
  resource :admin
  
  resources :attendances, only: [:create, :destroy]
  #get 'organizers/:id/organizerEvent', to: 'organizers#organizerEvent', as:'OrganizerEvent'
  get 'organizers/:id/manage_event' => 'organizers#manage_event', as:'manage_event'
  get 'vets/:id/my_events' => 'vets#my_events', as:'my_events'

  get 'admin/event_index' => 'admin#event_index'
  get 'admin/vet_show/:id' => 'admin#vet_show'
  get 'admin/vet_show' => 'vets#index'
  get 'admin/validate_event/:id' => 'admin#validate_event'
  patch 'admin/validate_event/:id' => 'admin#update', as: :validate_event

  get 'vets/new' => 'vets#new'
  post 'vets/validate_claim_profile' => 'vets#validate_claim_profile'
  get 'vets/claimed_profile' => 'vets#claimed_profile'
  post 'vets/create' => 'vets#create'
  get 'claim_profile' => 'vets#new'
  
  
  get 'organizers/new' => 'organizer#new' 

  get 'create_event' => 'events#new'
  
  root "static_pages#home"
  get "static_pages/home"
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
