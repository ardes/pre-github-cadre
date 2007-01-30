require 'key_event/generate'

class Signup < Event
  include KeyEvent::Generate
  
  delegate  :display_name, :display_name=, :email, :email=, :email_confirmation, :email_confirmation=,
            :password, :password=, :password_confirmation, :password_confirmation=,
            :to => :user
  
  # build user on demand (because of delegation above)
  def user_with_build(*args)
    user_without_build(*args) || build_user
  end
  alias_method_chain :user, :build
  
  validates_associated :user
  
  # merge user errors
  after_validation {|signup| signup.user.errors.each {|a, m| signup.errors.add(a, m)}}
  
  after_create do |signup|
    CadreNotifier.deliver_signed_up(signup) if signup.send_email?
  end
  
  attr_accessor_with_default :send_email, true
  
  def send_email?
    send_email == true
  end
end