require 'key_event/has'

class NonActivatedUserEvent < UserEvent
  include KeyEvent::Has
  
  has_key_event :signup
  
  def user_with_signup(*args)
    user_without_signup(*args) or ((self.user = signup.user) rescue raise ArgumentError, "assign signup before accessing user")
  end
  alias_method_chain :user, :signup
  
  before_validation do |event|
    event.user # load user and user_id
  end
  
  validate_on_create do |event|
    event.errors.add(:user, 'is already activated') if event.user && event.user.activated?
  end
end