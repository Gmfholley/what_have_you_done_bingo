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
      
  # admin controller actions to control members of group
  get 'organizations/:organization_id/users/:id' => 'organization_users#new'
  post 'organizations/:organization_id/users/:id' => 'organization_users#create'
  put 'organizations/:organization_id/users/:id' => 'organization_users#update', as: :organization_user
  patch 'organizations/:organization_d/users/:id' => 'organization_users#update'
  delete 'organizations/:organization_id/users/:id' => 'organization_users#destroy'
  
  # public sign up pages for users to create or destroy group
  get 'organizations/:id/sign_up' => 'organization_signup#new', as: :organization_sign_up
  post 'organizations/:id/sign_up' => 'organization_signup#create'
  delete 'organization/:id/remove'  => 'organization_signup#destroy'
  
  
  get 'organization/:id/update_token' => 'organizations#update_token', as: :update_organization_token
  
  resources :users, except: [:edit, :update, :destroy, :index]
  
  resources :organizations, except: :index do
    resources :templates, except: :index
  end
  get 'play/:token' => 'cards#new', as: :share_template #path for sharing the template
  post 'play/:token' => 'cards#create'
  
  resources :cards, except: :new, :create
  get 'cards/:token/share' => 'cards#share', as: :share_card

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
