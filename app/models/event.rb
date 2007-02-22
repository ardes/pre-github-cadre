require 'active_record/singleton'
require 'cadre/key_event/has'

# Class heirachy:
#   Event
#       Signup
#           ActivationSignup
#       UserEvent
#           NonActivatedUserEvent
#               SignupCancellation
#               Activation
#           ActivatedUserEvent
#               Recognition
#               Login
#               PasswordResetRequest
#               PasswordReset
#
class Event < ActiveRecord::Base
  extend Cadre::KeyEvent::Has
  belongs_to :user
  
  attr_protected :user_id, :created_at

  validates_format_of :ip_address, :allow_nil => true, :with => /\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/
  
  # All events are readonly after they have been created
  def create(*args)
    result = super(*args)
  ensure
    readonly! if result
  end
  
  def after_find
    readonly!
  end
  
  # return true if this is a saved record of the specifed class (default Event)
  def saved?(klass = Event)
    !new_record? && is_a?(klass)
  end
  
  # return a name of this event
  def name
    "#{self.class.name.titleize}: #{user.email rescue 'unknown user'}"
  end
  
  # return a description of this event
  def description
    "#{self.class.name.titleize} by #{"#{user.name} (#{user.email})" rescue 'guest'} from #{ip_address || 'unknown ip address'} at #{created_at}" unless new_record?
  end
  
  # singleton container for class-wide properties
  class Properties < ActiveRecord::Base
    include ActiveRecord::Singleton
  end
end