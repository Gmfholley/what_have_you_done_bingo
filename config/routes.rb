Rails.application.routes.draw do

  root 'welcome#index'

  # there is no index of profiles
  # profiles is *your* site
  # users/:id is somebody else's

  # there is no index of users (that appears on the organization page)
  
  get 'profile' => 'profile#show', as: :profile
  put 'profile' => 'profile#update'
  patch 'profile' => 'profile#update'
  delete 'profile' => 'profile#destroy'
  get 'profile/edit' => 'profile#edit', as: :edit_profile
  
  resources :users, except: [:edit, :update, :destroy, :index]
  get 'organizations/:id/sign_up' => 'users#new', as: :organization_sign_up
  post 'organizations/:id/sign_up'
  
  get 'organizations/:id/users/:user_id' => 'organization_users#new'
  put 'organizations/:id/users/:user_id' => 'organization_users#update', as: :organization_user
  patch 'organizations/:id/users/:user_id' => 'organization_users#update'
  delete 'organizations/:id/users/:user_id' => 'organization_users#destroy'
  post 'organizations/:id/users/:user_id' => 'organization_users#create'
  
  
  resources :organizations, except: :index do
    resources :templates, except: :index    
  end
  get 'play/:token' => 'templates#share', as: :share_template #path for sharing the template


  post 'password_resets' => 'password_resets#create', as: :password_resets
  get 'password_resets/:id/edit' => 'password_resets#edit', as: :edit_password_resets
  put 'password_resets/:id' => 'password_resets#update', as: :password_reset
  patch 'password_resets/:id' => 'password_resets#update'

  post 'login' => 'user_sessions#create', as: :login
  get 'login' => 'user_sessions#new'
  delete 'logout' => 'user_sessions#destroy', as: :logout
  
      
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
