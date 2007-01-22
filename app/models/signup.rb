class Signup < Event
  include Event::GenerateKey
  
  delegate *User.delegate_methods.push(:to => :user)
  
  when_nil :user do |signup|
    signup.build_user
  end
  
  validates_associated :user
  
  after_validation do |signup| # merge user errors
    signup.user.errors.each {|a, m| signup.errors.add(a, m)} 
  end
  
  after_create do |signup|
    SignupNotifier.deliver_activate_your_account(signup) if signup.send_email?
  end
  
  attr_accessor_with_default :send_email, true
  
  def send_email?
    send_email == true
  end
end