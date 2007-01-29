ActionController::Routing::Routes.draw do |map|
  map.sign_up 'sign_up', :controller => 'signups', :action => 'new'
  map.resources :signups
  
  map.activate 'activate/:signup_id/:signup_key', :controller => 'activations', :action => 'new'
  map.resources :activations
  
  map.cancel_signup 'cancel/:signup_id/:signup_key', :controller => 'signup_cancellations', :action => 'new'
  map.resources :signup_cancellations
  
  map.resources :activation_signups
  
  map.request_reset_password 'iforgot/:user_id', :controller => 'password_reset_requests', :action => 'new'
  map.resources :password_reset_requests
  
  map.reset_password 'reset/:request_id/:request_key', :controller => 'password_resets', :action => 'new'
  map.resources :password_resets
   
  map.resource :account, :controller => 'account'
  
  map.resources :events

  map.resources :users

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end
