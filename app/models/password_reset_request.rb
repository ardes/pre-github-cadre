require 'cadre/key_event/generate'

class PasswordResetRequest < ActivatedUserEvent
  include Cadre::KeyEvent::Generate
  
  attr_accessor :email
  
  validates_presence_of :email
  
  before_validation do |request|
    request.user = User.find_by_email(request.email)
  end
  
  validate_on_create do |request|
    request.errors.add(:email, 'is not recognised') unless request.user
  end
  
  after_create do |request|
    CadreNotifier.deliver_requested_reset_password(request)
  end
end