Bee2::Application.routes.draw do

  get "tracks/alllastpoint" => 'tracks#all_last_point', :as => 'all_last_point'
  get "tracks/:driver_id/last" => 'tracks#last', :as => 'track_last'
  post "tracks/:driver_id/show2" => 'tracks#show2', :as => 'track_show2'
  get "tracks/" => 'tracks#index', :as => 'tracks'
  get "tracks/:driver_id/show" => 'tracks#show', :as => 'track_show'

  post "api/:login/:password/setcoord" => 'api#setcoord', :as => 'api_setcoord'

  get "api/:login/:password/goal" => 'api#goal', :as => 'api_goal'

  post "api/:login/:password/zvonkiupd" => 'api#zvonkiupd', :as => 'api_zvonkiupd'

  post "api/:login/:password/caronorder" => 'api#caronorder', :as => 'api_caronorder'
  post "api/:login/:password/dispreg" => 'api#dispreg', :as => 'api_dispreg'

  post "api/:login/:password/stateupd" => 'api#state_update', :as => 'api_state_update'

  get "api/:login/:password/reforders" => 'api#refresh_orders', :as => 'api_refresh_orders'
  post "api/:login/:password/qpush" => 'api#push_in_queue', :as => 'api_qpush'
  
  post "api/:login/:password/orderdestroy" => 'api#order_destroy', :as => 'api_order_destroy'
  post "api/:login/:password/order" => 'api#order_update', :as => 'api_order_update'

  get "api/:login/:password/order" => 'api#order', :as => 'api_order'
  get "api/:login/:password/queue" => 'api#queue', :as => 'api_queue'
  get "api/test" => 'api#test', :as => 'api_test'
  
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    get 'logout' => :destroy
  end

  get "about/index"
  root 'about#index'

  post '*a', :to => 'about#errors'
  get '*a', :to => 'about#errors'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'about#index'

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
