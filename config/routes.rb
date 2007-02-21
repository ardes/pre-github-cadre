ActionController::Routing::Routes.draw do |map|
  map.sign_up 'sign_up', :controller => 'signups', :action => 'new'
  
  map.activate 'activate/:signup_id/:signup_key', :controller => 'activations', :action => 'new'
  
  map.cancel_signup 'cancel/:signup_id/:signup_key', :controller => 'signup_cancellations', :action => 'new'
  
  map.request_reset_password 'iforgot/:user_id', :controller => 'password_reset_requests', :action => 'new'
  
  map.reset_password 'reset/:request_id/:request_key', :controller => 'password_resets', :action => 'new'
   
  map.resources :signups, :activations, :activation_signups, :signup_cancellations,
                :logins, :recognitions, :password_reset_requests, :password_resets
  
  map.resource :account, :controller => 'account'
  
  map.resources :users do |users|
    users.resources :events, :name_prefix => 'user_', :controller => 'user_events'
  end

  map.resources :events

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end
