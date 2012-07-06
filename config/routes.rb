NokiaRuby::Application.routes.draw do


  get "admin_settings/index"
  #$$$$$$$$$$$$$khaled$$$$$$$$$$$$$$$$$$$$$$  
  match "mob/stories/recommend_success_mobile_show/:sid" => "stories#recommend_success_mobile_show"
  #$$$$$$$$$$$$$$$$$$$khaled$$$$$$$$$$$$$$

 # ~~~~~~~~~~~~~~~~ 3OBAD ~~~~~~~~~~~~~~~~~~~~~~~~

  match "mob/edit/info" => "users#edit"
  post "mob/info/update" => "users#update"
  match "mob/flickr/authenticate" => "flickr_accounts#auth"
  match "mob/flickr/callback" => "flickr_accounts#callback"
  match "mob/flickr/delete" => "flickr_accounts#delete_account"

 # ~~~~~~~~~~~~~~~~ 3OBAD ~~~~~~~~~~~~~~~~~~~~~~~~


	# $$$$$$$$$$$$$$ KIRO $$$$$$$$$$$$$$$$$$$$$$$$$
	match "requestToken" => "user_sessions#requestToken"
	match "login" => "user_sessions#login_with_token"
	match "register" => "users#register"
	match "mob/resetPassword" => "users#resetPassword"
	match "dummyLogin" => "users#dummyLogin"
	match "mob/test" => "users#test"
	match "mob/test_2" => "users#test_2"
  match "mob/forgot_password" => "users#forgot_password"
	match "mob/verifySettings" => "users#verifySettings"
	match "mob/verifyAccount" => "users#verifyAccount"
	match "mob/resendCode" => "users#resendCode"
	match 'logout', :controller => 'user_sessions', :action => 'destroy'
	resources :user_sessions
	resources :users
	# $$$$$$$$$$$$$$ KIRO $$$$$$$$$$$$$$$$$$$$$$$$$

# $$$$$$$$$$$$$$  OMAR $$$$$$$$$$$$$$$$$$$$$$$
  match "/stories/:id/get" => "stories#get"
  match "mob/toggle" => "users#toggle"   
  match "mob/int_toggle" => "users#int_toggle"
  match "mob/story_feed" => "stories#get_story_feed"
# $$$$$$$$$$$$$$  OMAR $$$$$$$$$$$$$$$$$$$$$$$ 



  #match "users/mobile_show/edit" => "users#edit"
  #post  "users/mobile_show/update" => "users#update"
  match "h_accounts/:id/profile" => "h_accounts#profile"
  match "users/:id/stories" => "users#feed"
  post  "h_accounts/sign_in"
  post  "h_accounts/password" => "h_accounts#forgot_password"
  match 'stories/get_friend_id' => 'stories#get_friend_id'

        # $$$$$$$$$$$$$$ RANA $$$$$$$$$$$$$$$$$$$$$$$$$ 
  match 'mob/block_story/:id' => 'users#block_story'
  match 'mob/block_interest/:id' => 'users#block_interest'
  match 'mob/block_friends_feed/:id' => 'users#block_friends_feed'
  match 'mob/friends_feed/:id' => 'users#friends_feed'
  match 'mob/manage_blocked_friends' => 'users#manage_blocked_friends'
  match 'mob/unblock_friends_feed/:id' => 'users#unblock_friends_feed'
  match 'mob/manage_blocked_stories' => 'users#manage_blocked_stories'
  match 'mob/unblock_story/:id' => 'users#unblock_story'
  match 'mob/unblock_story_from_undo/:id' => 'users#unblock_story_from_undo'
  match 'mob/block_interest_from_toggle/:id' => 'users#block_interest_from_toggle'
  match 'mob/unblock_interest_from_toggle/:id' => 	'users#unblock_interest_from_toggle'
  match 'mob/unblock_interest/:id' => 'users#unblock_interest'
        # $$$$$$$$$$$$$$ RANA $$$$$$$$$$$$$$$$$$$$$$$$$
        
  #$$$$$$$$$$$$$$$$ MINA $$$$$$$$$$$$$$$$$$$$$$$
  match "mob/main_feed" => "users#feed"
  match "mob/shares/:id" => "shares#user_share_story"
  match "mob/settings" => "users#settings"
  match "mob/facebook" => "users#facebook_feed"
  match "mob/twitter" => "users#twitter_feed"
  match "mob/flickr" => "users#flickr_feed"
  match "mob/tumblr" => "users#tumblr_feed"
  match "mob/share" => "users#share_story"
  #$$$$$$$$$$$$$$$$ MINA $$$$$$$$$$$$$$$$$$$$$$$
	





  match "users/index" => "users#index"
  match "/users/new" => "users#create", :as => :create
 
  match "/h_accounts/create" => "h_accounts#create", :as => :create
 
 
 
  
  # $$$$$$$$$$$$$$ Christine $$$$$$$$$$$$$$$$$$$$$$$$$
  match "/interests/statistics/:id" => "statistics#interests"
  match "/stories/statistics/:id" => "statistics#stories"
  match "/users/statistics/:id" => "statistics#users"
  match "admins/statistics/all_users" => "statistics#all_users"
  match "admins/statistics/all_interests" => "statistics#all_interests"
  match "admins/statistics/all_stories" => "statistics#all_stories"
  match "users/:id" => "users#show", :as => :user
  # $$$$$$$$$$$$$$ Christine $$$$$$$$$$$$$$$$$$$$$$$$$

  
  match "/admins/index" => "admins#index"
  
  match "h_accounts/verify" => "verification_codes#verify"
  match "h_accounts/:id/resend" => "verification_codes#resend"
  match "h_accounts" => "h_accounts#index"
  match "/users/:id" => "users#feed"
  
  #Author: Lydia############
  match "/admins/search" => "admins#search"
  match "/admins/all_results" => "admins#all_results"
  match "/admins/filter" => "admins#filter"
  ##########################

  match "/interests/list"  => "interests#new", :as => :new

 match "interests/:id/toggle" => "interests#toggle"

#--------------------Kareem------------------------
  match "user_add_interests/interests" => "user_add_interests#get_interests" 
  match "likedislikes/thumb" => "likedislikes#thumb"
  match "users/:id/stories" => "users#feed"
  match "flags/flag" => "flags#flag"
#-------------------END---------------------------- 




  # $$$$$$$$$$$$$$  YAHIA $$$$$$$$$$$$$$$$$$$$$$$
  match "mob/twitter/generate_request_token" => "twitter_accounts#generate_request_token"
  match "mob/twitter/generate_access_token" => "twitter_accounts#generate_access_token"
  match "mob/twitter/disconnect" => "twitter_accounts#delete_account"
  match "mob/connect_network" => "users#connect_social_accounts"
  match "mob/friendship/search/" => "friendships#search"
  match "mob/friendship/search/:query" => "friendships#search"
  match "mob/friendship/create/:friend_id" => "friendships#create"
  match "mob/friendship/reject/:friend_id" => "friendships#remove"
  match "mob/friendship/remove_request/:friend_id" => "friendships#remove_request"
  match "mob/friendship/block/:friend_id" => "friendships#block"
  match "mob/friendship/unblock/:friend_id" => "friendships#unblock"
  match "mob/friendship/pending" => "friendships#pending"
  match "mob/friendship/accept/:friend_id" => "friendships#accept"
  match "mob/friendship/index" => "friendships#index"
  # $$$$$$$$$$$$$$  YAHIA  END $$$$$$$$$$$$$$$$$$$
  
  # $$$$$$$$$$$$$$  MENISY $$$$$$$$$$$$$$$$$$$$$$$
  match "mob/stories/:id/comments/new" => "stories#create_comment"
  match "mob/stories/:id/comments/upc" => "stories#up_comment"
  match "mob/stories/:id/comments/downc" => "stories#down_comment"
  match "mob/stories/:id/show_mob/" => "stories#mobile_show"
  match "/fb/done" => "facebook_account#authenticate_facebook_done"
  match "mob/facebook/auth_init" => "facebook_account#authenticate_facebook_init"
  match "mob/facebook/delete" => "facebook_account#delete_account"
  # $$$$$$$$$$$$ MENISY END $$$$$$$$$$$$$$$$$$$$$$

    # $$$$$$$$$$$$$$ Khaled $$$$$$$$$$$$$$$$$$$$$$$$$

  match "mob/stories/recommend_success_mobile_show/:sid" => "stories#recommend_success_mobile_show"
  match "mob/stories/recommend_story_mobile_show/:sid" => "stories#recommend_story_mobile_show"
  match "mob/stories/liked_mobile_show/:id" => "stories#liked_mobile_show", :as => :like
  match "mob/stories/disliked_mobile_show/:id" => "stories#disliked_mobile_show", :as => :dislike
   # $$$$$$$$$$$$$$ Khaled $$$$$$$$$$$$$$$$$$$$$$$$$

   #$$$$$$$$$$$$$$$$$$$$$ BASSEM !! $$$$$$$$$$$$$$$$$$
   match "users/deactivate/:id" => "users#deactivate"
   match "users/activate/:id" => "users#activate"
   match "stories/filter" => "stories#filter"
   match "/admin_settings" => "admin_settings#index"
   match 'admin_settings/statistics_time_span' => 'admin_settings#statistics_time_span'
   #$$$$$$$$$$$$$$$$$$$$$ BASSEM !! $$$$$$$$$$$$$$$$$$


  #match "users/" => "users#index"
  match "users/" => "users#index"
  match '/pages/home' => 'pages#home'

  match 'interests/feeds/create' => 'feeds#create'
  resources :feeds

  match "check" => "verification_codes#check"

  #match "/feeds/:id" => "feeds#create"
  #match "/feeds/delete/:id" => "feeds#destroy"  
 
 
  
  


  root :to => 'admins#index'
  
 # resources :users
 # resources :h_accounts

  resources :admins
  resources :stories
  resources :interests
  resources :shares 
  resources :comments
  resources :admin_sessions
  resources :password_resets



  resources :gaheem_accounts
  #resources :friends
# $$$$$$$$$$$$$$$$$$ MESAI $$$$$$$$$$$$$$$$$$$$$$$
  post "/autocomplete/auto_complete_for_autocomplete_query" => "autocomplete#auto_complete_for_autocomplete_query"
  resources :logs, :except => [:delete,:show]  
  match '/logs/filter/', to: 'logs#filter'
  match '/logs/search/', to: 'logs#search'
  match '/logs/filterbydate/', to: 'logs#filter_by_date'
  match '/logs/interest/:id', to: 'logs#get_specific_interest'
  match '/logs/stories/:id', to: 'logs#get_specific_story'
  match '/logs/users/:id', to: 'logs#get_specific_user'
  match '/logs/admins/:id', to: 'logs#get_specific_admin'
#L $$$$$$$$$$$$$$$$ MESAI $$$$$$$$$$$$$$$$$$$$$$$
  
  # $$$$$$$$$$$$$$ GASSER $$$$$$$$$$$$$$$$$$$$$$$
  match 'admin_settings/configure_auto_hiding', to: 'admin_settings#configure_auto_hiding'
  match '/users/force_reset_password/:id', to: 'users#force_reset_password'
  #get 'admin_settings', to: 'admin_settings#index'
  post 'admin_settings/configure_flags_threshold', to: 'admin_settings#configure_flags_threshold'  
  # $$$$$$$$$$$$$$ GASSER $$$$$$$$$$$$$$$$$$$$$$$
  #Mouaz
  match '/admin/login', to: 'admin_sessions#new'
  match '/admin/logout', to: 'admin_sessions#destroy'
  match '/admin_settings', to: 'admin_settings#edit'
  match '/password_resets/new', to: 'password_resets#new'
  match '/password_resets/edit', to: 'password_resets#edit'
 # match 'forgot_password' => 'admin_sessions#forgot_password_lookup_email', :as => :forgot_password, :via => :post

 # put 'reset_password/:reset_password_code' => 'admins#reset_password_submit', :as => :reset_password, :via => :put
  #get 'reset_password/:reset_password_code' => 'admins#reset_password', :as => :reset_password, :via => :get 
 
  # $$$$$$$$$$$$$$ Shafei $$$$$$$$$$$$$$$$$$$$$$$$$
   match 'admin/statistics/all_users', to: 'statistics#all_users'
   get 'admin/statistics/all_users', to: 'statistics#all_users'
  # $$$$$$$$$$$$$$ Shafei $$$$$$$$$$$$$$$$$$$$$$$$$ 
   
   
   # $$$$$$$$$$$$$$ Essam $$$$$$$$$$$$$$$$$$$$$$$
     match "mob/tumblr/login" => "tumblr_accounts#login"
     match 'mob/tumblr/connect_tumblr' => 'tumblr_accounts#connect_tumblr'
     match "mob/tumblr/delete" => "tumblr_accounts#delete_account"
   # $$$$$$$$$$$$$$ Essam $$$$$$$$$$$$$$$$$$$$$$$
   
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
