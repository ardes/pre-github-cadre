class SignupCancellationsController < EventsController
  resources_controller_for :signup_cancellations
  
  def create
    params[resource_name] = {:signup_key => params[:signup_key], :signup_id => params[:signup_id]}
    super
  end
end
