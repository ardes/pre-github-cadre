class NonActivatedUserEvent < UserEvent
  has_key_event :signup
  
  def user_with_signup(*args)
    user_without_signup(*args) or ((self.user = signup.user) rescue raise ArgumentError, "assign signup before accessing user")
  end
  alias_method_chain :user, :signup
  
  validate_on_create do |event|
    event.errors.add(:user, 'is already activated') if event.user && event.user.activated?
  end
end