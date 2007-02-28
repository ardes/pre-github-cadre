class SignupsController < EventsController
  resources_controller_for :signups
  
  skip_before_filter :authenticate, :require_admin, :only => [:new, :create]
end
