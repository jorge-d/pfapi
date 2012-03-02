Pfapi::Application.routes.draw do

  resources :scores
  resources :users

  match 'get_zone_id' => 'ApiRequests#getZoneId'
  match 'get_zone_by_id' => 'ApiRequests#getZoneById'
  match 'get_unlocked_zones' => 'ApiRequests#getUnlockedZones'
  match 'get_score_from_zone' => 'ApiRequests#getScoreFromZone'
  match 'get_unlocked_zones_number' => 'ApiRequests#getUnlockedZonesNumber'
  match 'get_score_from_player' => 'ApiRequests#getScoreFromPlayer'
  match 'send_score_from_player' => 'ApiRequests#sendScoreFromPlayer'
  match 'get_credentials' => 'ApiRequests#getCredentials'
  match 'unlock_zones_arround' => 'ApiRequests#unlockZonesArround'
  match 'get_players_in_zone' => 'ApiRequests#getPlayersInZone'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'users#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'


  ## sould handle routing errors
  # match "*a", :to => "application#routing_error"
  # match "*a", to: redirect('/')

end
