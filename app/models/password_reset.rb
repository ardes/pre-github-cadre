class PasswordReset < ActivatedUserEvent
  has_key_event :request, :class => PasswordResetRequest
  
  delegate :password, :password=, :password_confirmation, :password_confirmation=, :to => :user
  
  validates_associated :user
  
  # load user from password reset request
  def user(*args)
    super(*args) || self.user = request.user rescue nil
  end
  
  # merge user errors
  after_validation do |reset|
    reset.user.errors.each {|attr, msg| reset.errors.add(attr, msg)} 
  end
  
  after_create do |reset|
    Notifier.deliver_reset_password(reset) if reset.user.save
  end
end