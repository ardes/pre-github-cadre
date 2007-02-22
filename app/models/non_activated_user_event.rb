class NonActivatedUserEvent < UserEvent
  has_key_event :signup
  
  # load user from signup
  def user(*args)
    super(*args) or self.user = signup.user rescue nil
  end
  
  validate_on_create do |event|
    event.errors.add(:user, 'is already activated') if event.user && event.user.activated?
  end
end