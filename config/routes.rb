ActionController::Routing::Routes.draw do |map|
  map.resources :users

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end
