# Parent of Activation and FalseSignup.
#
# This class encapsulates the functionality of requiring a Signup event in
# order to infer the user and create the event.
class WithSignupEvent < UserEvent
  attr_protected :signup
  attr_accessor :signup, :signup_id, :signup_key
  
  def signup
    @signup ||= (Signup.find_by_id_and_key(signup_id, signup_key) rescue nil)
  end
    
  before_validation do |event|
    event.user = event.signup.user if event.signup
  end
  
  validate_on_create do |event|
    event.errors.add(:signup, "is not valid") unless event.signup.is_a?(Signup) && !event.signup.new_record?
    event.errors.add(:user, 'is already activated') if event.user && event.user.activated?
  end
end