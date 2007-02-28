require 'cadre/key_event/generate'

class Login < ActivatedUserEvent
  include Cadre::KeyEvent::Generate

  attr_accessor :email, :password
  
  validates_presence_of :email, :password
  
  before_validation do |login|
    login.user = User.find_by_email(login.email)
  end
  
  # we delibrately don't give much away in terms of validation errors
  validate_on_create do |login|
    login.errors.add(:user, 'could not be authenticated') unless login.user && login.user.activated? && login.user.authenticate_password(login.password)
  end
end