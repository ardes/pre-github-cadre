class PasswordResetRequest < ActivatedUserEvent
  include Event::GenerateKey
end