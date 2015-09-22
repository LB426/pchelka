Bee2::Application.routes.draw do

  post 'defset/credit-policy/destroy' => 'defsets#destroy_credit_policy', :as => 'destroy_defset_credit_policy'
  post 'defset/credit-policy/update'  => 'defsets#update_credit_policy',  :as => 'update_defset_credit_policy'
  get  'defset/credit-policy/edit'    => 'defsets#edit_credit_policy',    :as => 'edit_defset_credit_policy'
  post 'defset/credit-policy/create'  => 'defsets#create_credit_policy',  :as => 'create_defset_credit_policy'
  get  'defset/credit-policy/new'     => 'defsets#new_credit_policy',     :as => 'new_defset_credit_policy'

  post 'defset/taximeter/destroy' => 'defsets#destroy_taximeter', :as => 'destroy_defset_taximeter'
  post 'defset/taximeter/update'  => 'defsets#update_taximeter',  :as => 'update_defset_taximeter'
  get  'defset/taximeter/edit'    => 'defsets#edit_taximeter',    :as => 'edit_defset_taximeter'
  post 'defset/taximeter/create'  => 'defsets#create_taximeter',  :as => 'create_defset_taximeter'
  get  'defset/taximeter/new'     => 'defsets#new_taximeter',     :as => 'new_defset_taximeter'

  post 'defset/monetary-unit/destroy' => 'defsets#destroy_monetary_unit', :as => 'destroy_defset_monetary_unit'
  post 'defset/monetary-unit/update'  => 'defsets#update_monetary_unit',  :as => 'update_defset_monetary_unit'
  get  'defset/monetary-unit/edit'    => 'defsets#edit_monetary_unit',    :as => 'edit_defset_monetary_unit'
  post 'defset/monetary-unit/create'  => 'defsets#create_monetary_unit',  :as => 'create_defset_monetary_unit'
  get  'defset/monetary-unit/new'     => 'defsets#new_monetary_unit',     :as => 'new_defset_monetary_unit'
  
  get 'defset/showall' => 'defsets#index', :as => 'showall_defsets'

  #resources :defsets

  post "api/:login/:password/smsdrivergotorder" => 'api#smsdrivergotorder', :as => 'api_smsdrivergotorder'
  post "api/:login/:password/smsdriverarrived" => 'api#smsdriverarrived', :as => 'api_smsdriverarrived'

  get "api/:login/:password/lastposmap" => 'api#lastposmap', :as => 'api_lastposmap'

  get "api/:login/:password/taximeter" => 'api#taximeter', :as => 'api_taximeter'

  post 'user/:id/destroy' => 'user#destroy', :as => 'user_destroy'
  post 'user/create' => 'user#create', :as => 'user_create'
  get 'user/new' => 'user#new', :as => 'user_new'

  post 'user/settings/credit-policy/massupdate' => 'user#mass_update_settings_credit_policy', :as => 'mupdate_creditpol_regdrv'
  get  'user/settings/credit-policy/edit/mass' => 'user#mass_edit_settings_credit_policy_reg_driver', :as => 'medit_creditpol_regdrv'

  post 'user/:id/settings/credit-policy/update' => 'user#update_settings_credit_policy', :as => 'update_user_settings_credit_policy'
  get  'user/:id/edit/settings/credit-policy'   => 'user#edit_settings_credit_policy',   :as => 'edit_user_settings_credit_policy'
  
  post 'user/:id/settings/taximeter/massupdate' => 'user#mass_update_settings_taximeter', :as => 'user_mass_update_settings_taximeter'
  get 'user/mass-assign-taximeter-for-regular-driver' => 'user#mass_assign_taximeret_reg_driver', :as => 'user_mass_assign_taximeret_reg_driver'

  post 'user/:id/settings/taximeter/update' => 'user#update_settings_taximeter', :as => 'user_update_settings_taximeter'
  get 'user/:id/settings/taximeter' => 'user#settings_taximeter', :as => 'user_show_settings_taximeter'
  
  post 'user/:id/update' => 'user#update', :as => 'user_update'
  get 'user/:id/edit' => 'user#edit', :as => 'user_edit'
  get 'user/showall'
  get 'user/index'

  get "api/:login/:password/getlastdrivercoord" => 'api#getlastdrivercoord', :as => 'api_getlastdrivercoord'
  
  get "api/:login/:password/alarm" => 'api#alarm', :as => 'api_alarm'

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
