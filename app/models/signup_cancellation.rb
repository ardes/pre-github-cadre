class SignupCancellation < NonActivatedUserEvent
  after_create do |cancel|
    cancel.user.destroy
  end
end