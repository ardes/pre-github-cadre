class SignupCancellation < WithSignupEvent
  after_create do |cancel|
    cancel.user.destroy
  end
end