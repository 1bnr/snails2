Rails.application.routes.draw do
  resources :deposits
  resources :accounts
  devise_for :users, controllers: { confirmations: 'confirmations' }
  resources :snacks
  resources :orders
  resources :line_items

  namespace "snacks" do
      # Put your resources here, as however you defined them before, e.g.:  
      resources :deposits, :accounts, :users, :snacks, :orders, :line_itmes, :deposits
  end
  
  devise_scope :user do
      get "users/show", to: "users/sessions#show"
      get "users/new", to: "users/sessions#new"
      post "users/create", to: "users/sessions#create"
      get "users/edit", to: "users/registrations#edit"
      put "users/update", to: "users/registrations#update"
  end

  root "orders#new"
#  get 'orders/:id/show_order' => 'orders#show_order'
  post 'orders/purchase' => 'orders#purchase'
  post 'orders/view_cart' => 'orders#view_cart'

  post 'line_items/update' => 'line_items#update'
  post 'deposits/update' => 'deposits#update'
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
