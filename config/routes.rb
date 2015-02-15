SkillCounter::Application.routes.draw do

  resources :payments 
  #devise_for :user_logins, controllers: { registrations: "sessions" }

  devise_for :users
  resources :users do
    member do 
      resources :external_events, except: [:index], path: :custom_events
    end
  end

  
  resources :events 
  resources :organizers
  resources :vets
    
  resources :admin, only: [:new, :create]

  resources :transactions, except: [:new] do
    #
    # Modify the new_transaction path to take a parameter 'payment_type', 
    # which we'll use to determine what sort of payment we're doing. 
    #
    new do
      get ':payment_type/:vet_id/:payment_id' => 'transactions#new', as: '' # this will give us 'new_transaction'
    end
    collection do
      get 'pay_to_claim' => 'transactions#pay_to_claim'
      post 'express_checkout' => 'transactions#express_checkout', as: :express_checkout
      get 'successful' => 'transactions#successful'
      get 'failed' => 'transactions#failed'
      get 'cancelled' => 'transactions#cancelled'
    end
  end

  
  resources :attendances, only: [:create, :destroy, :import, :update, :download] do
    collection do

      patch 'events/:id' => 'attendances#import', as: :import
      put 'present' => 'attendances#present', as: :update
      get '/events/:id' => 'attendances#download', as: :download
      post 'events/:id/event_sign_up' => 'attendances#event_sign_up', as: :event_sign_up
      delete 'events/:id/cancel_sign_up' => 'attendances#destroy', as: :cancel_sign_up
    end
  end
  #get 'organizers/:id/organizerEvent', to: 'organizers#organizerEvent', as:'OrganizerEvent'
  get 'users/:id/admin_event' => 'users#admin_event', as:'admin_event'
  get 'users/:id/user_event' => 'users#user_event', as:'user_event'
  get 'users/:id/check_event' => 'users#check_event', as:'check_event'
  get 'organizers/:id/manage_event' => 'organizers#manage_event', as:'manage_event'
  get 'vets/:id/vet_event' => 'vets#vet_event', as:'vet_event'
  get 'vets/:id/my_events' => 'vets#my_events', as:'my_events'
  get 'vets/:id/redeem_licence' => 'vets#redeem_licence', as:'redeem_licence'
  patch 'users/:id/event_validate/:event_id' => 'admin#check', as: :event_validate


  get 'admin/event_index' => 'admin#event_index' 
  get 'admin/vet_show/:id' => 'admin#vet_show'
  get 'admin/vet_show' => 'vets#index'
  get 'admin/validate_event/:id' => 'admin#validate_event', as: :validate_event
  get 'admin/upload_vets' => 'admin#upload_vets'
  post 'admin/upload_vets' => 'admin#save_uploaded_vets'
  patch 'admin/validate_event/:id' => 'admin#update'
  get 'admin/pending_index' => 'admin#pending_index', as: :admin_pending_index
  get 'admin/approved_index' => 'admin#approved_index', as: :admin_approved_index
  get 'admin/live_index' => 'admin#live_index', as: :admin_live_index
  get 'admin/dashboard' => 'admin#dashboard', as: :dashboard

  get 'vets/new' => 'vets#new'
  post 'vets/validate_claim_profile' => 'vets#validate_claim_profile'
  get 'vets/claimed_profile' => 'vets#claimed_profile'
  post 'vets/create' => 'vets#create'
  get 'claim_profile' => 'vets#new'
  
  
  get 'organizers/new' => 'organizer#new' 

  get 'create_event' => 'events#new'
  get 'event/purchase_points/:id'=> 'events#purchase_points', as: :purchase_points
  get 'event/upload_attendance/:id' => 'events#upload_attendance', as: :upload_attendance
  
  post 'event/express_checkout' => 'events#express_checkout', as: :express_checkout_events
  get 'event/event_payment_new' => 'events#event_payment_new', as: :event_payment_new
  get 'event/event_payment_cancel' => 'events#event_payment_cancel', as: :event_payment_cancel
  post 'event/event_payment_create' => 'events#event_payment_create', as: :event_payment_create
  post 'event/:id/approve_event' => 'events#approve_event', as: :approve_event

  post 'vet/express_checkout' => 'vets#express_checkout', as: :express_checkout_vets
  get 'vet/renew_licence_new' => 'vets#renew_licence_new', as: :renew_licence_new
  get 'vet/renew_licence_cancel' => 'vets#renew_licence_cancel', as: :renew_licence_cancel
  post 'vet/renew_licence_create' => 'vets#renew_licence_create', as: :renew_licence_create
  

  get 'about' => 'static_pages#about'

  root 'static_pages#home'
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
