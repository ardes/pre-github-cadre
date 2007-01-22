ActionController::Routing::Routes.draw do |map|
  map.connect 'activate/:signup_id/:signup_key', :controller => 'activations', :action => 'new'
  map.resources :activations
  
  map.connect 'badsignup/:signup_id/:signup_key', :controller => 'false_signups', :action => 'new'
  map.resources :false_signups
  
  map.resources :signups
  
  map.resources :events

  map.resources :users

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end
