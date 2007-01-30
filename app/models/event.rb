require 'active_record/singleton'
require 'key_event/has'

# Class heirachy:
#   Event
#     Signup
#       ActivationSignup
#     UserEvent
#       NonActivatedUserEvent
#         SignupCancellation
#         Activation
#       ActivatedUserEvent
#         Recognition
#         Login
#         PasswordResetRequest
#         PasswordReset
class Event < ActiveRecord::Base
  extend KeyEvent::Has
  belongs_to :user
  
  attr_protected :user_id, :created_at

  validates_format_of :ip_address, :allow_nil => true, :with => /\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/
  
  # All events are readonly after they have been created
  def create(*args)
    result = super(*args)
  ensure
    readonly! if result
  end
  
  def after_find;
    readonly!;
  end
  
  # return true if this is a saved record of the specifed class (default Event)
  def saved?(klass = Event)
    is_a?(klass) && !new_record?
  end
  
  # singleton container for class-wide properties
  class Properties < ActiveRecord::Base
    include ActiveRecord::Singleton
  end
end