class PasswordReset < ActivatedUserEvent
  has_key_event :request, :class => PasswordResetRequest
  
  delegate :password, :password=, :password_confirmation, :password_confirmation=, :to => :user
  
  validates_associated :user
  
  def user_with_request(*args)
    user_without_request(*args) or ((self.user = request.user) rescue raise ArgumentError, "assign request before accessing user")
  end
  alias_method_chain :user, :request

  # merge user errors
  after_validation do |signup|
    signup.user.errors.each {|attr, msg| signup.errors.add(attr, msg)} 
  end
  
  after_create do |reset|
    CadreNotifier.deliver_reset_password(reset) if reset.user.save
  end
end