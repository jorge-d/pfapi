Pfapi::Application.routes.draw do

  resources :zones
  resources :games
  resources :users do
    resources :scores
    resources :unlocked_zones
  end

  scope 'api' do 
    get 'checkout_zone', to: 'ApiRequests#checkout_zone' # Convert into post after tests
    get 'unlock_zones_arround', to: 'ApiRequests#unlock_zones_arround' # Convert into post after tests
    get 'checkout_score', to: 'ApiRequests#checkout_score' # Convert into post after tests
    get 'zone_informations_by_id', to: 'ApiRequests#zone_informations_by_id'
    get 'unlocked_zones', to: 'ApiRequests#unlocked_zones'
    get 'best_score_from_zone_by_id', to: 'ApiRequests#best_score_from_zone_by_id'
    get 'unlocked_zones_number', to: 'ApiRequests#unlocked_zones_number'
    get 'best_score_from_player' => 'ApiRequests#best_score_from_player'
    get 'credentials' => 'ApiRequests#credentials'
    get 'players_in_zone' => 'ApiRequests#players_in_zone'
    get 'total_score_from_player' => 'ApiRequests#total_score_from_player'
  end

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
  match "*a", :to => "application#routing_error"
  # match "*a", to: redirect('/')

end
