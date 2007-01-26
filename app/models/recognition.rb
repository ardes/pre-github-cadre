class Recognition < ActivatedUserEvent
  # a recognition can be issued with just a user_id
  attr_protected.delete :user_id
end