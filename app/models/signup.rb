class Signup < Event
  include Event::GenerateKey
  
  delegate *User.delegate_methods.push(:to => :user)
  
  # build user on demand
  def user_with_build(*args)
    user_without_build(*args) or build_user
  end
  alias_method_chain :user, :build
  
  validates_associated :user
  
  # merge user errors
  after_validation do |signup|
    signup.user.errors.each {|attr, msg| signup.errors.add(attr, msg)} 
  end
  
  after_create do |signup|
    UserNotifier.deliver_activate_your_account(signup) if signup.send_email?
  end
  
  attr_accessor_with_default :send_email, true
  
  def send_email?
    send_email == true
  end
end