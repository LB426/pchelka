# coding: utf-8
Bee2::Application.routes.draw do

###############################################################
# отказаться от призовой поездки
###############################################################
  post "api/:login/:password/order/priz/refuse" => 'api#order_refuse_priz', :as => 'api_order_refuse_priz'

###############################################################
# работа с заказом для диспетчерской программы
###############################################################
  post "api/:login/:password/order/create" => 'api#order_create', :as => 'api_order_create'

###############################################################
# построение маршрута
###############################################################
  get "api/:login/:password/routetoclient" => 'api#routetoclient', :as => 'api_routeto_client'
###############################################################
# манипуляции с очередью
###############################################################
  # поставить машину в очередь в определённый регион
  post "api/:login/:password/queue" => 'api#queue_create',      :as => 'api_queue_create'
  # просмотр очереди for drivers
  get  "api/:login/:password/queue" => 'api#queue',             :as => 'api_queue'
  # переключение режима обработки очереди 0 - автоматически, 1 - ручной
  post "api/:login/:password/mpinq" => 'api#queue_exec_manual', :as => 'api_queue_exec_manual'
  # удалить из очереди
  delete  "api/:login/:password/queue" => 'api#queue_remove_car',  :as => 'api_queue_remove_car' 
###############################################################
# работа с заказами для новой андроидной программы
# #############################################################
  # поставить себя на заказ
  post "api/:login/:password/order/addcar"   => 'api#orderaddcar',   :as => 'api_order_car_add'
  # снять себя с заказа
  post "api/:login/:password/order/delcar"   => 'api#orderdelcar',   :as => 'api_order_car_del'
  # получить список заказов
  get  "api/:login/:password/orders"         => 'api#orders',        :as => 'api_orders'  
  # отработка нажатия на кнопку расчёт закончен
  post "api/:login/:password/order/complete" => 'api#ordercomplete', :as => 'api_order_complete'
  # получить список районов с координатами
  get  "api/:login/:password/defset/regions" => 'api#regions',       :as => 'api_defset_regions'
###############################################################  
  get 'user/driver/monetary_credit/decrease' => 'user#driver_monetary_credit_dec', :as => 'driver_moncred_dec'
###############################################################
# работа с настройками по умолчанию
###############################################################
  post 'defset/region/:id/destroy'=> 'defsets#destroy_parking_region',      :as => 'destroy_defset_parking_region'
  post 'defset/region/:id/update' => 'defsets#update_parking_region',       :as => 'update_defset_parking_region'
  get  'defset/region/:id/edit'   => 'defsets#edit_parking_region',         :as => 'edit_defset_parking_region'
  post 'defset/region/create' => 'defsets#create_parking_region',       :as => 'create_defset_parking_region'
  get  'defset/region/new'    => 'defsets#new_parking_region',          :as => 'new_defset_parking_region'
  get  'defset/regions'       => 'defsets#index_defset_parking_region', :as => 'index_defset_parking_region'

  post 'defset/time/dec/score/driver/regular/destroy' => 'defsets#destroy_time_dec_score_regdrv', :as => 'destroy_defset_time_dec_score_regdrv' 
  post 'defset/time/dec/score/driver/regular/update'  => 'defsets#update_time_dec_score_regdrv',  :as => 'update_defset_time_dec_score_regdrv' 
  get  'defset/time/dec/score/driver/regular/edit'    => 'defsets#edit_time_dec_score_regdrv',    :as => 'edit_defset_time_dec_score_regdrv' 
  post 'defset/time/dec/score/driver/regular/create'  => 'defsets#create_time_dec_score_regdrv',  :as => 'create_defset_time_dec_score_regdrv' 
  get  'defset/time/dec/score/driver/regular/new'     => 'defsets#new_time_dec_score_regdrv',     :as => 'new_defset_time_dec_score_regdrv' 

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
  
  get  'defset/showall' => 'defsets#index', :as => 'showall_defsets'

  #resources :defsets

  post "api/:login/:password/smsdrivergotorder" => 'api#smsdrivergotorder', :as => 'api_smsdrivergotorder'
  post "api/:login/:password/smsdriverarrived" => 'api#smsdriverarrived', :as => 'api_smsdriverarrived'

  get "api/:login/:password/lastposmap" => 'api#lastposmap', :as => 'api_lastposmap'

  get "api/:login/:password/taximeter" => 'api#taximeter', :as => 'api_taximeter'

  post 'user/:id/score/update' => 'user#update_score', :as => 'update_user_score'
  get 'user/:id/score' => 'user#edit_score', :as => 'edit_user_score'

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

  post "api/:login/:password/setcoord"     => 'api#setcoord',      :as => 'api_setcoord'
  get  "api/:login/:password/goal"         => 'api#goal',          :as => 'api_goal'
  post "api/:login/:password/zvonkiupd"    => 'api#zvonkiupd',     :as => 'api_zvonkiupd'
  post "api/:login/:password/dispreg"      => 'api#dispreg',       :as => 'api_dispreg'
  post "api/:login/:password/stateupd"     => 'api#state_update',  :as => 'api_state_update'
  get  "api/:login/:password/reforders"    => 'api#refresh_orders',:as => 'api_refresh_orders'
  post "api/:login/:password/orderdestroy" => 'api#order_destroy', :as => 'api_order_destroy'
  post "api/:login/:password/order"        => 'api#order_update',  :as => 'api_order_update'
  get  "api/:login/:password/order"        => 'api#order',         :as => 'api_order'
  get  "api/test"                          => 'api#test',          :as => 'api_test'
  
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    get 'logout' => :destroy
  end

  get "about/index"
  root 'about#index'

  #post '*a', :to => 'about#errors'
  #get '*a', :to => 'about#errors'
  
end
