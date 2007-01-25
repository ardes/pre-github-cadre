class PasswordResetRequest < ActivatedUserEvent
  include Event::GenerateKey
  
  # a password reset request can be issued with just a user_id
  attr_protected.delete :user_id
  
  after_create do |request|
    CadreNotifier.deliver_requested_reset_password(request)
  end
end