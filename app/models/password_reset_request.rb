class PasswordResetRequest < ActivatedUserEvent
  include Event::GenerateKey
  
  attr_protected.delete :user_id
end