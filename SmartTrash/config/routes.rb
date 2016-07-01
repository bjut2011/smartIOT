Rails.application.routes.draw do
  resources :userdevices
  resources :alarmlogs
  resources :schedulers
  get 'dmaps/layout' =>"dmaps#layout"
  resources :dmaps
  resources :contacts
  resources :sensors
  get 'alarms/toAddAlarms' =>"alarms#toAddAlarms"
  get 'alarms/toUpdateAlarms' =>"alarms#toUpdateAlarms"
  post 'alarms/querySensorByDeviceId' =>"alarms#querySensorByDeviceId"
  post 'alarms/addAlarms' =>"alarms#addAlarms"
  post 'queryAlarmlogs' =>"alarmlogs#queryAlarmlogs"
  post 'alarms/:id/update' =>"alarms#update"
  get 'devices/monitor' =>"devices#monitor"
  get 'devices/layout' =>"devices#layout"
  get 'devices/explore' =>"devices#explore"
  get 'devices/queryLineData' =>"devices#queryLineData"
  post 'devices/:id/update' =>"devices#update"
  post 'devices/getDevices' =>"devices#getDevices"
  post 'history' =>"devices#history"
  get 'history' =>"devices#history"
  post 'goHistoryLine' =>"devices#goHistoryLine"
  get 'goHistoryLine' =>"devices#goHistoryLine"
  get 'sensorlogs/getData' =>"sensorlogs#getData"
  post 'sensorlogs/getData' =>"sensorlogs#getData"
  post 'querySensorHistoryDatas' =>"sensorlogs#querySensorHistoryDatas"
  post 'querySensorDataDetail' =>"sensors#querySensorDataDetail"
  get 'getSensorsByID' =>"sensors#getSensorsByID"
  resources :devices
  resources :projects
  resources :sensorlogs
  get 'home/index'
  #root to: "home#index"
  root to: "users#login"
  get 'login' => 'users#login'
  get 'register' => 'users#register'
  post 'register' => 'users#register'
  post 'login' => 'users#create_login_session'
  delete 'logout' => 'users#logout'
  get 'logout' => 'users#logout'
  get '/users/toUpdatePassword' => 'users#toUpdatePassword'
  post '/users/toUpdatePassword' => 'users#toUpdatePassword'
  get 'devicebinding' => 'users#devicebinding'
  post 'users/binding' => 'users#binding'
  post 'users/delbinding' => 'users#delbinding'
  #get 'login' => 'sessions#new'
  #get 'login' => 'sessions#new'
  #post 'login' => 'sessions#create'
  #delete 'logout' => 'sessions#destroy'
  resources :alarms
  resources :users
  resources :gateways
  resources :devices
  resources :projects
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
